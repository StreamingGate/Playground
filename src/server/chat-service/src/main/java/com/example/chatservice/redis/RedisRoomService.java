package com.example.chatservice.redis;

import com.example.chatservice.exception.CustomChatException;
import com.example.chatservice.exception.ErrorCode;
import com.example.chatservice.model.chat.Chat;
import com.example.chatservice.model.chat.SenderRole;
import com.example.chatservice.model.room.Room;
import com.example.chatservice.utils.RedisMessaging;
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
public class RedisRoomService {
    private static final String CHAT_ROOMS = "CHAT_ROOM";
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisSubscriber redisSubscriber;
    private HashOperations<String, String, Room> opsHashRoom;
    private Map<String, ChannelTopic> topics;

    @PostConstruct
    private void init() {
        opsHashRoom = RedisMessaging.getOpsHashRoom();
        topics = new HashMap<>();
    }

    public List<Room> findAll() {
        return opsHashRoom.values(CHAT_ROOMS);
    }

    public Room findById(String roomId) {
        return opsHashRoom.get(CHAT_ROOMS, roomId);
    }

    public Room create(String name) {
        Room room = new Room(name);
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room);
        return room;
    }

    public int addPinnedChat(String roomId, Chat pinnedChat) throws CustomChatException {
        if (!pinnedChat.getSenderRole().equals(SenderRole.STREAMER))
            throw new CustomChatException(ErrorCode.C001, roomId);

        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        room.getPinnedChats().add(pinnedChat);
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room); //update
        return room.getPinnedChats().size();
    }

    /**
     * 채팅방 입장 : "현재 서버"에 roomId에 해당하는 topic이 없으면 맵에 저장해놓고, pub/sub 통신을 하기 위해 리스너를 추가한다.
     */
    public int enter(String roomId) {
        ChannelTopic topic = topics.get(roomId);
        if (topic == null) {
            topic = new ChannelTopic(roomId);
            redisMessageListener.addMessageListener(redisSubscriber, topic);
            topics.put(roomId, topic);
        }
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        int userCnt = room.addUser();
        log.info("add user:" + room.getId() + " " + userCnt + "명");
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room); //update
        return userCnt;
    }

    public int exit(String roomId) throws IllegalArgumentException {
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        if (room == null) throw new IllegalArgumentException("존재하지 않는 방입니다.");
        int userCnt = room.removeUser();
        log.info("remove user:" + room.getId() + " " + userCnt + "명");
        opsHashRoom.put(CHAT_ROOMS, room.getId(), room); //update
        return userCnt;
    }

    public int getUserCnt(String roomId) throws IllegalArgumentException {
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        if (room == null) throw new IllegalArgumentException("존재하지 않는 방입니다.");
        return room.getUserCnt();
    }

    public ChannelTopic getTopic(String roomId) {
        ChannelTopic ct = topics.get(roomId);
        log.info("ChannelTopic: " + ct);
        if (ct != null) log.info("ChannelTopic: " + ct.getTopic());
        return ct;
    }
}