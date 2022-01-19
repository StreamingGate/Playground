package com.example.chatservice.service;

import java.util.List;

import javax.transaction.Transactional;

import com.example.chatservice.dto.ChatDto;
import com.example.chatservice.entity.chat.Chat;
import com.example.chatservice.entity.chat.ChatRepository;
import com.example.chatservice.entity.room.Room;
import com.example.chatservice.entity.room.RoomRepository;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {

    private final ChatRepository chatRepository;
    private final RoomRepository roomRepository;
    
    /**
     * 결국 Chat이 아닌 Room을 업데이트하는 것
     * @param chatDto
     */
    public void create(ChatDto chatDto){
        log.info("create start..");
        Room room = roomRepository.findById(chatDto.getRoomId())
        .orElseThrow(() -> new NullPointerException("존재하지 않는 방입니다."));
        log.info("findRoom end..");
        room.getChats().add(chatDto.toEntity());
        log.info("add chat end..");
        
        roomRepository.save(room);        // TODO: mapper로 바꾸기
    }
    
    @Transactional
    public List<Chat> findByRoomId(String roomId) {
        return chatRepository.findAllByRoomId(roomId);
    }

    @Transactional
    public List<Chat> findAll() {
        return chatRepository.findAll();
    }

}
