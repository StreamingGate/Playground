package com.example.chatservice.dto;

import java.time.LocalDateTime;

import com.example.chatservice.entity.chat.Chat;
import com.example.chatservice.entity.chat.ChatType;
import com.example.chatservice.entity.chat.SenderRole;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;



@NoArgsConstructor
@Getter
public class ChatDto {

    private String roomId;
    private String nickname;
    private SenderRole senderRole;
    private ChatType chatType;          // TEST: STREAMER & (PINNED || NORMAL) , reverse
    private String message;
    private LocalDateTime timestamp;    // TODO: 혹시 dto받으면서 변경되진 않는지 확인

    public Chat toEntity() {
        return Chat.builder()
                .nickname(nickname)
                .senderRole(senderRole)
                .chatType(chatType)
                .message(message)
                .timestamp(timestamp)
                .build();
    }

    public static ChatDto from(Chat chat){
        return ChatDto.builder()
                .nickname(chat.getNickname())
                .senderRole(chat.getSenderRole())
                .chatType(chat.getChatType())
                .message(chat.getMessage())
                .timestamp(chat.getTimestamp())
                .build();
    }

    @Builder
    public ChatDto(String roomId,
     String nickname,
     SenderRole senderRole,
     ChatType chatType,
     String message,
     LocalDateTime timestamp){
         this.nickname = nickname;
         this.roomId = roomId;
         this.senderRole = senderRole;
         this.chatType = chatType;
         this.message = message;
         this.timestamp= timestamp;
     }


}