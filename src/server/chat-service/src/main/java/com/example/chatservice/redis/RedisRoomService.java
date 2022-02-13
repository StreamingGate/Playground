package com.example.chatservice.redis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.PostConstruct;
import com.example.chatservice.exception.CustomChatException;
import com.example.chatservice.exception.ErrorCode;
import com.example.chatservice.dto.chat.ChatConsume;
import com.example.chatservice.dto.chat.ChatProduce;
import com.example.chatservice.dto.chat.SenderRole;
import com.example.chatservice.dto.room.Room;
import com.example.chatservice.utils.RedisMessaging;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class RedisRoomService {

    private static final String CHAT_ROOMS = "CHAT_ROOM";
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisSubscriber redisSubscriber;
    private HashOperations<String, String, Room> opsHashRoom; // 방 관리에 사용하는 Redis 연산자
    private Map<String, ChannelTopic> topics; // 서버별로 roomId에 매치되는 topic정보를 넣는다.

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

    public Room create(String uuid, String hostUuid) {
        Room room = new Room(uuid, hostUuid);
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room);
        return room;
    }

    public void addPinnedChat(String roomId, ChatProduce pinnedChat) throws CustomChatException {
        if (!pinnedChat.getSenderRole().equals(SenderRole.STREAMER))
            throw new CustomChatException(ErrorCode.C001, roomId);

        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        room.updatePinnedChat(new ChatConsume(pinnedChat));
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room); // update
    }

    /**
     * 채팅방 입장 : "현재 서버"에 roomId에 해당하는 topic이 없으면 맵에 저장해놓고, pub/sub 통신을 하기 위해 리스너를
     * 추가한다.
     */
    public int enter(String roomId) {
        getOrAddTopic(roomId);
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);

        int userCnt = room.addUser();
        log.info("add user:" + room.getUuid() + " " + userCnt + "명");
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room); // update
        return userCnt;
    }

    public int exit(String roomId) throws IllegalArgumentException {
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        if (room == null)
            throw new IllegalArgumentException("존재하지 않는 방입니다.");
        int userCnt = room.removeUser();
        log.info("remove user:" + room.getUuid() + " " + userCnt + "명");
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room); // update
        return userCnt;
    }

    public int getUserCnt(String roomId) throws IllegalArgumentException {
        Room room = opsHashRoom.get(CHAT_ROOMS, roomId);
        if (room == null)
            throw new IllegalArgumentException("존재하지 않는 방입니다.");
        return room.getUserCnt();
    }

    public ChannelTopic getOrAddTopic(String roomId) {
        ChannelTopic channelTopic = topics.get(roomId);
        if (channelTopic == null) {
            channelTopic = new ChannelTopic(roomId);
            redisMessageListener.addMessageListener(redisSubscriber, channelTopic);
            topics.put(roomId, channelTopic);
        }
        return channelTopic;
    }
}