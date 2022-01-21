package com.example.chatservice.redis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import com.example.chatservice.model.chat.Chat;
import com.example.chatservice.model.chat.SenderRole;
import com.example.chatservice.model.room.Room;

import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Repository
public class RedisRoomRepository {
    // 채팅방(topic)에 발행되는 메시지를 처리할 Listner
    private final RedisMessageListenerContainer redisMessageListener;
    // 구독 처리 서비스
    private final RedisSubscriber redisSubscriber;
    private final RedisTemplate<String, Object> redisTemplate;
    private HashOperations<String, String, Room> opsHashRoom; 
    private static final String CHAT_ROOMS = "CHAT_ROOM";

    // 채팅방의 대화 메시지를 발행하기 위한 redis topic 정보. 서버별로 roomId에 매치되는 topic정보를 넣는다.
    private Map<String, ChannelTopic> topics;

    // public RedisRoomRepository(RedisMessageListenerContainer redisMessageListenerContainer,
    //                            RedisSubscriber redisSubscriber, RedisTemplate<String, Object> redisTemplate) {
    //     this.redisMessageListener = redisMessageListenerContainer;
    //     this.redisSubscriber= redisSubscriber;
    //     this.redisTemplate = redisTemplate;
    // }

    @PostConstruct
    private void init() {
        opsHashRoom = redisTemplate.opsForHash();
        topics = new HashMap<>();
    }

    public List<Room> findAll() {
        return opsHashRoom.values(CHAT_ROOMS);
    }

    public Room findById(String roomId) {
        return opsHashRoom.get(CHAT_ROOMS, roomId);
    }

    /**
     * 채팅방 생성 : 서버간 채팅방 공유를 위해 redis hash에 저장한다.
     */
    public Room create(String name) {
        Room room = new Room(name);
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room);
        return room;
    }

    public int addPinnedChat(Chat pinnedChat) throws IllegalArgumentException{
        // 권한 확인
        log.info("SenderRole: " + pinnedChat.getSenderRole());
        if(!pinnedChat.getSenderRole().equals(SenderRole.STREAMER)){
            throw new IllegalArgumentException("Sender Role is not invalid");
        }
        Room room = opsHashRoom.get(CHAT_ROOMS, pinnedChat.getRoomId());
        room.getPinnedChats().add(pinnedChat);
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room); //update
        return room.getPinnedChats().size();
    }

    /**
     * 채팅방 입장 : "현재 서버"에 roomId에 해당하는 topic이 없으면 맵에 저장해놓고, pub/sub 통신을 하기 위해 리스너를 추가한다.
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
        ChannelTopic ct = topics.get(roomId);
        log.info("ChannelTopic: " + ct);
        if(ct != null) log.info("ChannelTopic: " + ct.getTopic());
        return ct;
    }
}