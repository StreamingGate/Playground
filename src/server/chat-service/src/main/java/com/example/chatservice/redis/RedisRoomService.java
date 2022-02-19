package com.example.chatservice.redis;

import com.example.chatservice.dto.chat.ChatConsume;
import com.example.chatservice.dto.chat.ChatProduce;
import com.example.chatservice.dto.chat.SenderRole;
import com.example.chatservice.dto.room.Room;
import com.example.chatservice.dto.room.RoomResponseDto;
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

    public RoomResponseDto findById(String roomUuid) {
        Room room = opsHashRoom.get(CHAT_ROOMS, roomUuid);
        return new RoomResponseDto(room);
    }

    public RoomResponseDto create(String roomUuid) {
        Room room = new Room(roomUuid);
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room);
        return new RoomResponseDto(room);
    }

    public boolean addPinnedChat(String roomUuid, ChatProduce pinnedChat) {
        if (!pinnedChat.getSenderRole().equals(SenderRole.STREAMER)) {
            log.warn("유효하지 않은 권한으로 채팅 고정을 시도합니다..");
//            throw new CustomChatException(ErrorCode.C001, roomUuid);
            return false;
        }

        Room room = opsHashRoom.get(CHAT_ROOMS, roomUuid);
        room.updatePinnedChat(new ChatConsume(pinnedChat));
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room); // update
        return true;
    }

    /* 채팅방 입장(접속자 수 증가) */
    public void enter(String roomUuid, String userUuid) {
        ChannelTopic channelTopic = getOrAddTopic(roomUuid);
        Room room = opsHashRoom.get(CHAT_ROOMS, roomUuid);

        int userCnt = room.addUser(userUuid);
        log.info("room enter:" + room.getUuid() + " " + userCnt + "명");
        opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room);

        RedisMessaging.publish(channelTopic, new ChatProduce(roomUuid, userCnt));
    }

    /* 채팅방 퇴장(접속자 수 감소) */
    public void exit(String roomUuid, String userUuid, String senderRole)  {
        ChannelTopic channelTopic = getOrAddTopic(roomUuid);
        Room room = opsHashRoom.get(CHAT_ROOMS, roomUuid);

        /* 스트리머 퇴장시 채팅방 삭제 */
        if (senderRole.equals(SenderRole.STREAMER.toString())) {
            removeRoom(room.getUuid());
        }
        else {
            int userCnt = room.removeUser(userUuid);
            log.info("room exit:" + room.getUuid() + " " + userCnt + "명");
            opsHashRoom.put(CHAT_ROOMS, room.getUuid(), room);
            RedisMessaging.publish(channelTopic, new ChatProduce(roomUuid, userCnt));
        }
    }

    /* 채팅방 삭제 */
    public String removeRoom(String roomUuid) {
        ChannelTopic channelTopic = topics.get(roomUuid);
        if (channelTopic != null) {
            topics.remove(roomUuid);
        }
        opsHashRoom.delete(CHAT_ROOMS, roomUuid);
        return roomUuid;
    }

    public ChannelTopic getOrAddTopic(String roomUuid) {
        ChannelTopic channelTopic = topics.get(roomUuid);
        if (channelTopic == null) {
            channelTopic = new ChannelTopic(roomUuid);
            redisMessageListener.addMessageListener(redisSubscriber, channelTopic);
            topics.put(roomUuid, channelTopic);
        }
        return channelTopic;
    }
}