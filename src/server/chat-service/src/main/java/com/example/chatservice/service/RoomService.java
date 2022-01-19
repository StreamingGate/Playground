package com.example.chatservice.service;


import com.example.chatservice.entity.room.Room;
import com.example.chatservice.entity.room.RoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class RoomService {

    private final RoomRepository roomRepository;

    public Room create(String name) {
        Room room = new Room(name);
        roomRepository.save(room);
        return room;
    }

    public Room findById(String id) {
        return roomRepository.findById(id).orElseThrow(() -> new NullPointerException("존재하지 않는 방 입니다."));
    }

    public Room findByName(String name) {
        return roomRepository.findByName(name).orElseThrow(() -> new NullPointerException("존재하지 않는 방 입니다."));
    }

    public List<Room> findAll() {
        return roomRepository.findAll();
    }
}
