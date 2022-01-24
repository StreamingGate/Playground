//package com.example.chatservice.mongodb;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//import com.example.chatservice.entity.chat.Chat;
//import com.example.chatservice.entity.chat.ChatRepository;
//import com.example.chatservice.entity.chat.ChatType;
//import com.example.chatservice.entity.chat.SenderRole;
//import com.example.chatservice.entity.room.Room;
//import com.example.chatservice.entity.room.RoomRepository;
//
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
//import static org.assertj.core.api.Assertions.assertThat;
//@DataMongoTest
//public class ChatRepositoryTest {
//
//    private static final String ROOM_NAME = "test room";
//    private static final String CHAT_NICKNAME = "testnickname";
//    private static final String CHAT_MESSAGE = "hello playground!🎁";
//
//    @Autowired
//    private ChatRepository chatRepository;
//
//    @Autowired
//    private RoomRepository roomRepository;
//
//    @DisplayName("CRUD: 채팅을 Room에 저장하면 Room조회시 채팅조회도 가능하다(연관관계확인)")
//    @Test
//    public void saveChatAndFindChatByRoomId() {
//        //given
//        Room savedRoom = new Room(ROOM_NAME);
//        String ROOM_ID = savedRoom.getId();
//        Chat chat1 = Chat.builder()
//                .roomId(ROOM_ID)
//                .senderRole(SenderRole.VIEWER)
//                .chatType(ChatType.NORMAL)
//                .message(CHAT_MESSAGE)
//                .nickname(CHAT_NICKNAME)
//                .timestamp(LocalDateTime.now())
//                .build();
//        Chat chat2 = Chat.builder()
//                .roomId(ROOM_ID)
//                .senderRole(SenderRole.VIEWER)
//                .chatType(ChatType.NORMAL)
//                .message(CHAT_MESSAGE)
//                .nickname(CHAT_NICKNAME)
//                .timestamp(LocalDateTime.now())
//                .build();
//        savedRoom.getChats().add(chat1);
//        savedRoom.getChats().add(chat2);
//        roomRepository.save(savedRoom);
//
//        //when
//        Room room = roomRepository.findById(ROOM_ID).orElse(null);
//
//        //then
//        assertThat(room).isNotNull();
//        assertThat(room.getChats().size()).isEqualTo(2);
//    }
//}
