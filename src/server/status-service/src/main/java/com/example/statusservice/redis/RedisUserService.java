package com.example.statusservice.redis;

import com.example.statusservice.entity.User.User;
import com.example.statusservice.entity.User.UserRepository;
import com.example.statusservice.utils.RedisMessaging;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Service;
import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <h1>RedisRoomService</h1>
 * <pre>
 *     Fields:
 *     - opsHashRoom: 방 관리에 사용하는 Redis 연산자
 *     - topics: 채팅방의 대화 메시지를 발행하기 위한 redis topic 정보. 서버별로 roomId에 매치되는 topic정보를 넣는다.
 * </pre>
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class RedisUserService {

    private static final String USER_LIST = "USER_LIST";
    private final UserRepository userRepository;
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisSubscriber redisSubscriber;
    private HashOperations<String, String, User> opsHashUser; // USER_LIST, uuid, friends
    private Map<String, ChannelTopic> topics;

    @PostConstruct
    private void init() {
        opsHashUser = RedisMessaging.getOpsHashUser();
        topics = new HashMap<>();
    }

    public List<User> findAll() {
        return opsHashUser.values(USER_LIST);
    }

    public User findById(String uuid) {
        User user = opsHashUser.get(USER_LIST, uuid);
        if(user == null){
            user = userRepository.findByUuid(uuid).orElseThrow();
            opsHashUser.put(USER_LIST, uuid, user);
        }
        return user;
    }

    /**
     * 로그인
     */
    public void login(String uuid) {
        ChannelTopic topic = topics.get(uuid);
        if (topic == null) {
            topic = new ChannelTopic(uuid);
            redisMessageListener.addMessageListener(redisSubscriber, topic);
            topics.put(uuid, topic);
        }
    }

    public ChannelTopic getTopic(String uuid) {
        ChannelTopic ct = topics.get(uuid);
        if (ct != null) log.info("ChannelTopic: " + ct.getTopic());
        return ct;
    }
}