package com.example.chatservice.redis;

import com.example.chatservice.dto.RoomDto;
import com.example.chatservice.entity.room.Room;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Repository;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Repository
public class RedisRoomRepository {
    // 채팅방(topic)에 발행되는 메시지를 처리할 Listner
    private final RedisMessageListenerContainer redisMessageListener;
    // 구독 처리 서비스
    private final RedisSubscriber redisSubscriber;
    // Redis
    private static final String CHAT_ROOMS = "CHAT_ROOM";
    private final RedisTemplate<String, Object> redisTemplate;
    private HashOperations<String, String, Room> opsHashChatRoom; // 방id, 방 만 저장됨.
    /**
     * redis에 topic이란 걸 방Id와 매칭시켜줘야 다중서버에서
     */
    // 채팅방의 대화 메시지를 발행하기 위한 redis topic 정보. 서버별로 채팅방에 매치되는 topic정보를 Map에 넣어 roomId로 찾을수 있도록 한다.
    private Map<String, ChannelTopic> topics;

    @PostConstruct
    private void init() {
        opsHashChatRoom = redisTemplate.opsForHash();
        topics = new HashMap<>();
    }

    public List<RoomDto> findAll() {
        return opsHashChatRoom.values(CHAT_ROOMS).stream()
                .map(room -> RoomDto.from(room))
                .collect(Collectors.toList());
    }

    public RoomDto findById(String id) {
        return RoomDto.from(opsHashChatRoom.get(CHAT_ROOMS, id));
    }

    /**
     * 채팅방 생성 : 서버간 채팅방 공유를 위해 redis hash에 저장한다.
     */
    public RoomDto create(String name) {
        Room room = new Room(name);
        opsHashChatRoom.put(CHAT_ROOMS, room.getId(), room);

        // roomId로 topic 생성
        ChannelTopic topic = new ChannelTopic(room.getId());
        redisMessageListener.addMessageListener(redisSubscriber, topic);
        topics.put(room.getId(), topic);
        log.info("=="+room.getId()+", "+topics.get(room.getId()));
        return RoomDto.from(room);
    }

    /**
     * 채팅방 입장 : "현재 서버"에 roomId에 해당하는 topic이 없으면 맵에 저장해놓고, pub/sub 통신을 하기 위해 리스너를 설정한다.
     */
    public void enter(String roomId){
        ChannelTopic topic = topics.get(roomId);
        if (topic == null) {
            topic = new ChannelTopic(roomId);
            redisMessageListener.addMessageListener(redisSubscriber, topic);
            topics.put(roomId, topic);
        }
    }

    public ChannelTopic getTopic(String roomId) {
        ChannelTopic ct =  topics.get(roomId);
        log.info("ct: " + ct);
        if(ct != null) log.info("ct: " + ct.getTopic());
        return ct;
    }
}