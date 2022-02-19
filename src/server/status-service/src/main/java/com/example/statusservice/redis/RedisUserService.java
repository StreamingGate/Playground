package com.example.statusservice.redis;

import com.example.statusservice.dto.FriendDto;
import com.example.statusservice.dto.UserDto;
import com.example.statusservice.entity.User.User;
import com.example.statusservice.entity.User.UserRepository;
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
    @Transactional
    public List<UserDto> findAll(String uuid) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        List<UserDto> result = new LinkedList<>();

        if (userDto == null) {
            User user = userRepository.findByUuid(uuid).orElse(null);
            /* redis에 없으면 mariadb에서도 확인 */
            if(user == null) {
                log.error("uuid: "+ uuid + " MariaDB에 해당 유저가 없습니다.");
                return result;
            }
            userDto = new UserDto(user);
            opsHashUser.put(USER_LIST, uuid, userDto);
        } else {
            for (String friendUuid : userDto.getFriendUuids()) {
                result.add(opsHashUser.get(USER_LIST, friendUuid));
            }
        }
        return result;
    }

    /* MariaDB에서 Redis로 유저 리스트 가져와 저장 */
    @Transactional
    public void initRedis() {
        List<User> users = userRepository.findAll();
        for (User user : users) {
            opsHashUser.put(USER_LIST, user.getUuid(), new UserDto(user));
        }
    }

    /* 영상 시청 시 친구에게 내 상태 publish */
    public void publishWatching(String uuid, UserDto reqUserDto) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        if (userDto == null) {
            User user = userRepository.findByUuid(uuid).orElse(null);
            /* redis에 없으면 mariadb에서도 확인 */
            if(user == null) {
                log.error("publishWatching uuid: "+ uuid + " MariaDB에 해당 유저가 없습니다.");
                return;
            }
            userDto = new UserDto(user);
            opsHashUser.put(USER_LIST, uuid, userDto);
        }
        else {
            userDto.updateVideoOrRoom(uuid, reqUserDto);
            opsHashUser.put(USER_LIST, uuid, userDto);
            ChannelTopic channelTopic = addTopic(uuid);
            RedisMessaging.publish(channelTopic, userDto);
        }
    }

    /* 로그인 또는 로그아웃 시 친구에게 내 상태 publish */
    public void publishStatus(String uuid, Boolean status) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        if (userDto == null) {
            User user = userRepository.findByUuid(uuid).orElse(null);
            /* redis에 없으면 mariadb에서도 확인 */
            if(user == null) {
                log.error("publishStatus uuid: "+ uuid + " MariaDB에 해당 유저가 없습니다.");
                return;
            }
            userDto = new UserDto(user);
            opsHashUser.put(USER_LIST, uuid, userDto);
        }
        else{
            userDto.updateStatus(status);
            opsHashUser.put(USER_LIST, userDto.getUuid(), userDto);
            ChannelTopic channelTopic = addTopic(uuid);
            RedisMessaging.publish(channelTopic, userDto);
        }
    }


    /* 친구 추가(탈퇴하지 않은 회원의 요청임이 전제) */
    public void addFriend(FriendDto requestDto, FriendDto senderDto) {
        UserDto userDto = opsHashUser.get(USER_LIST, requestDto.getUuid());
        if (userDto == null) { /* 없는 유저라면 추가 FIXME: 친구가 처음 생긴 유저인 경우 해당 유저의 status 반영 안 됨 */
            userDto = new UserDto(requestDto);
            addTopic(requestDto.getUuid());
        }

        userDto.getFriendUuids().add(senderDto.getUuid());
        opsHashUser.put(USER_LIST, requestDto.getUuid(), userDto);
    }

    /* 친구 삭제(탈퇴하지 않은 회원의 요청임이 전제) */
    public void deleteFriend(FriendDto requestDto, FriendDto targetDto) {
        UserDto userDto = opsHashUser.get(USER_LIST, requestDto.getUuid());
        if (userDto == null) { /* 없는 유저라면 추가 FIXME: 친구가 처음 생긴 유저인 경우 해당 유저의 status 반영 안 됨 */
            userDto = new UserDto(requestDto);
            addTopic(requestDto.getUuid());
        }

        userDto.getFriendUuids().remove(targetDto.getUuid());
        opsHashUser.put(USER_LIST, requestDto.getUuid(), userDto);
    }

    /**
     * 친구 추가/삭제시 나, 친구의 친구 목록 업데이트하기 위해 publish
     *
     * @param type true (친구 추가인 경우) or false(친구 삭제인 경우)
     */
    public void publishAddOrDeleteFriend(boolean type, String uuid, String targetUuid) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        UserDto targetDto = opsHashUser.get(USER_LIST, targetUuid);
        ChannelTopic userTopic = null;
        ChannelTopic targetTopic = null;
        if (userDto != null) userTopic = addTopic(uuid);
        if (targetDto != null) targetTopic = addTopic(targetUuid);

        userDto.updateAddOrDelete(type, targetUuid);
        targetDto.updateAddOrDelete(type, uuid);
        RedisMessaging.publish(userTopic, userDto);
        RedisMessaging.publish(targetTopic, targetDto);
    }

    /* TODO 유저 탈퇴 api 생성 시 사용 */
    public void deleteUser(String uuid) {
        UserDto userDto = opsHashUser.get(USER_LIST, uuid);
        if (userDto != null) {
            // collection에서 remove하면 줄어든 size에 의해 동시성 예외가 발생하므로 iterator로 처리
            Iterator<String> iter = userDto.getFriendUuids().iterator();
            while (iter.hasNext()) {
                iter.next();
                iter.remove();
            }
            opsHashUser.delete(USER_LIST, uuid);
        }
    }

    /* 모든 유저에 대한 토픽 저장 */
    public void addTopics() {
        List<User> users = userRepository.findAll();
        for (User user : users) {
            addTopic(user.getUuid());
        }
    }

    public ChannelTopic addTopic(String uuid) {
        ChannelTopic topic = topics.get(uuid);
        if (topic == null) {
            topic = new ChannelTopic(uuid);
            redisMessageListener.addMessageListener(redisSubscriber, topic);
            log.info("==Add topic:" + topic);
            topics.put(uuid, topic);
            topic = topics.get(uuid);
        }
        return topic;
    }
}