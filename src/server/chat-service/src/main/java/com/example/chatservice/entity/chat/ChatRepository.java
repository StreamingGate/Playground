package com.example.chatservice.entity.chat;

import com.example.chatservice.entity.Chat;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ChatRepository extends MongoRepository<Chat,Long> {
    
}
