package com.example.chatservice.service;

import com.example.chatservice.dto.RoomDto;
import com.example.chatservice.entity.room.Room;
import com.example.chatservice.entity.room.RoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class RoomService {

    private final RoomRepository roomRepository;

    public RoomDto create(String name) {
        Room room = new Room(name);
        Room res = roomRepository.save(room);
        return RoomDto.from(res); // TODO : mapper 적용
    }

    public RoomDto findById(String id) {
        Room room = roomRepository.findById(id).orElseThrow(() -> new NullPointerException("존재하지 않는 방 입니다."));
        return RoomDto.from(room); // TODO : mapper 적용
    }

    public RoomDto findByName(String name) {
        Room room = roomRepository.findByName(name).orElseThrow(() -> new NullPointerException("존재하지 않는 방 입니다."));
        return RoomDto.from(room); // TODO : mapper 적용
    }

    public List<RoomDto> findAll() {
        return roomRepository.findAll()
                .stream().map(room -> RoomDto.from(room))
                .collect(Collectors.toList());
    }
}
