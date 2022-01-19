package com.example.chatservice.mongodb;

import java.time.LocalDateTime;
import java.util.List;

import com.example.chatservice.entity.chat.Chat;
import com.example.chatservice.entity.chat.ChatRepository;
import com.example.chatservice.entity.chat.ChatType;
import com.example.chatservice.entity.room.Room;
import com.example.chatservice.entity.room.RoomRepository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import static org.assertj.core.api.Assertions.assertThat;
@DataMongoTest
public class ChatRepositoryTest {
    
    private static final String ROOM_NAME = "test room";
    private static final String CHAT_NICKNAME = "testnickname";
    private static final String CHAT_MESSAGE = "hello playground!🎁";
    
    @Autowired
    private ChatRepository chatRepository;

    @Autowired
    private RoomRepository roomRepository;



    @DisplayName("채팅 저장 후 roomId로 chat까지 찾기(연관관계확인)")
    @Test
    public void saveChatAndFindChatByRoomId() {
        //given
        final Room savedRoom = roomRepository.save(new Room(ROOM_NAME));
        final String ROOM_ID = savedRoom.getId();
        final Chat chat1 = Chat.builder()
                .chatType(ChatType.NORMAL)
                .message(CHAT_MESSAGE)
                .nickname(CHAT_NICKNAME)
                .timestamp(LocalDateTime.now())
                .build();
        final Chat chat2 = Chat.builder()
                .chatType(ChatType.NORMAL)
                .message(CHAT_MESSAGE)
                .nickname(CHAT_NICKNAME)
                .timestamp(LocalDateTime.now())
                .build();

        Chat savedChat1 = chatRepository.save(chat1);
        Chat savedChat2 = chatRepository.save(chat2);
        
        //when
        Room room = roomRepository.findById(ROOM_ID).orElse(null);

        //then
        assertThat(room).isNotNull();
    }
}
