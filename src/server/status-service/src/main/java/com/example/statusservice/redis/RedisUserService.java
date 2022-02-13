package com.example.statusservice.redis;

import com.example.statusservice.dto.UserDto;
import com.example.statusservice.entity.User.User;
import com.example.statusservice.entity.User.UserRepository;
import com.example.statusservice.exception.CustomStatusException;
import com.example.statusservice.exception.ErrorCode;
import com.example.statusservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.PostConstruct;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Service
public class RedisUserService {

    private static final String USER_LIST = "USER_LIST";
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisSubscriber redisSubscriber;
    private final UserRepository userRepository;
    private HashOperations<String, String, UserDto> opsHashUser;   // 유저 데이터 관리에 사용하는 Redis 연산자
    private Map<String, ChannelTopic> topics;                   // 상태관리 서버 내부에서 관리하는 topic 저장소

    @PostConstruct
    private void init() {
        opsHashUser = RedisMessaging.getOpsHashUser();
        topics = new HashMap<>();
    }

    /* 내 친구들의 상태 조회 */
    public List<UserDto> findAll(String uuid){
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        if(userDto == null) {
            log.info(uuid + "해당 유저가 없습니다.");
            throw new CustomStatusException(ErrorCode.S001, uuid + "해당 유저가 없습니다.");
        }
        List<UserDto> result = new LinkedList<>();
        for(String friendUuid: userDto.getFriendUuids()){
            result.add(opsHashUser.get(USER_LIST, friendUuid));
        }
        return result;
    }

    /* MariaDB에서 Redis로 유저 리스트 가져와 저장 */
    @Transactional
    public void initRedis() {
        List<User> users = userRepository.findAll();
        for(User user: users){
            opsHashUser.put(USER_LIST, user.getUuid(), new UserDto(user));
//            RedisMessaging.setExpirationMinute(user.getUuid(), 30l); // 로그인시 30분마다 Redis데이터 갱신(친구 리스트 변동 반영)
        }
    }

    /* 영상 시청 시 친구에게 내 상태 publish */
    public void publishWatching(String uuid, UserDto reqUserDto){
        UserDto userDto = findByUuid(uuid);
        ChannelTopic channelTopic = getOrAddTopic(uuid);

        userDto.updateVideoOrRoom(uuid, reqUserDto);
        opsHashUser.put(USER_LIST, uuid, userDto);
        RedisMessaging.publish(channelTopic, userDto);
    }

    /* 로그인 또는 로그아웃 시 친구에게 내 상태 publish */
    public void publishStatus(String uuid, Boolean status) {
        UserDto userDto = findByUuid(uuid);
        ChannelTopic channelTopic = getOrAddTopic(uuid);

        userDto.updateStatus(status);
        opsHashUser.put(USER_LIST, userDto.getUuid(), userDto);
        RedisMessaging.publish(channelTopic, userDto);
    }

    /* Redis에서 유저 조회 후 상태 업데이트 (없으면 MariaDB에서 가져와 저장)*/
    @Transactional
    public UserDto findByUuid(String uuid) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        if(userDto == null){
            log.info("==Published uuid is null");
            User user = userRepository.findByUuid(uuid)
                    .orElseThrow(() -> new CustomStatusException(ErrorCode.S001, uuid, "해당 유저가 없습니다."));
            userDto = new UserDto(user);
//            RedisMessaging.setExpirationMinute(uuid, 30l); // 로그인시 30분마다 Redis데이터 갱신(친구 리스트 변동 반영)
            addFriends(user.getBeFriend());
            addTopics(user.getBeFriend());
        }

        return userDto;
    }

    /* Redis에 유저 리스트 추가(친구의 uuid도 topic으로 존재해야 publish가능하므로) */
    private void addFriends(List<User> friends){
        for(User u: friends){
            if(opsHashUser.get(USER_LIST, u.getUuid()) == null) {
                UserDto userDto = new UserDto(u);
                opsHashUser.put(USER_LIST, userDto.getUuid(), userDto);
//                RedisMessaging.setExpirationMinute(userDto.getUuid(), 30l);
            }
        }
    }

    /* 모든 유저에 대한 토픽 저장 */
    public void addTopics(){
        List<User> users  = userRepository.findAll();
        for(User user: users){
            getOrAddTopic(user.getUuid());
        }
    }

    /* 특정 유저 리스트에 대한 토픽 저장 */
    public void addTopics(List<User> users){
        for(User user: users){
            getOrAddTopic(user.getUuid());
        }
    }

    /* 여러 서버 간 통신을 위해 현재 리스너 등록 후 현 서버에 토픽 저장 */
    public ChannelTopic getOrAddTopic(String uuid) {
        ChannelTopic topic = topics.get(uuid);
        if (topic == null) {
            topic = new ChannelTopic(uuid);
            redisMessageListener.addMessageListener(redisSubscriber, topic);
            log.info("==Add topic:"+topic);
            topics.put(uuid, topic);
            topic = topics.get(uuid);
        }
        return topic;
    }
}