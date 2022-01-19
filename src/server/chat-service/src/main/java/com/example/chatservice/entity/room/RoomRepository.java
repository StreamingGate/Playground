 package com.example.chatservice.entity.room;

 import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

/**
 * <h1>RoomRespository</h1>
 * This repository uses Mariadb
 */
 public interface RoomRepository extends MongoRepository<Room, String> {

  Optional<Room> findByName(String name);
 }
