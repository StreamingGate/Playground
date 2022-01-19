 package com.example.chatservice.entity.room;

 import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * <h1>RoomRespository</h1>
 * This repository uses Mariadb
 */
 public interface RoomRepository extends JpaRepository<Room, String> {

  Optional<Room> findByName(String name);
 }
