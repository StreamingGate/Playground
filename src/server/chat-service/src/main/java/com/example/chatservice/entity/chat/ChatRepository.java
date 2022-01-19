package com.example.chatservice.entity.chat;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

/**
 * <h1>ChatRepository</h1>
 * This repository uses MongoDB
 */
public interface ChatRepository extends MongoRepository<Chat,Long> {
    
    List<Chat> findAllByRoomId(String id);
}
