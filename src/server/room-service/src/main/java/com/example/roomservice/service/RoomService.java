package com.example.roomservice.service;

import com.example.roomservice.dto.RequestDto;
import com.example.roomservice.dto.ResponseDto;
import com.example.roomservice.entity.Room.Room;
import com.example.roomservice.entity.Room.RoomRepository;
import com.example.roomservice.entity.RoomViewer.RoomViewer;
import com.example.roomservice.entity.RoomViewer.RoomViewerRepository;
import com.example.roomservice.exceptionHandler.customexception.CustomRoomException;
import com.example.roomservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class RoomService {
    private final RoomRepository roomRepository;
    private final ModelMapper mapper;
    private final AmazonS3Service amazonS3Service;
    private final RoomViewerRepository roomViewerRepository;

    @Transactional
    public ResponseDto join(Long roomId, String uuid) throws CustomRoomException {
        Room room = roomRepository.getById(roomId);
        RoomViewer roomViewer = roomViewerRepository.findByUserUuid(uuid);
        ResponseDto responseDto = mapper.map(room,ResponseDto.class);
        if (roomViewer == null) {
            roomViewerRepository.save(roomViewer.join(roomId, uuid,false));
            responseDto.setLiked(false);
            responseDto.setDisliked(false);
        }
        else {
            responseDto.setLiked(roomViewer.getLiked());
            responseDto.setDisliked(roomViewer.getDisliked());
        }
        responseDto.setRoomId(roomId);
        return Optional.of(responseDto).orElseThrow(()->new CustomRoomException(ErrorCode.L001));
    }

    @Transactional
    public ResponseDto create(RequestDto requestDto) throws CustomRoomException {
        roomRepository.save(Room.create(requestDto));
        ResponseDto responseDto = mapper.map(requestDto,ResponseDto.class);
        requestDto.setThumbnail(amazonS3Service.upload(requestDto.getThumbnail(),requestDto.getUuid()));
        RoomViewer roomViewer = roomViewerRepository.findByUserUuid(requestDto.getHostUuid());
        Long roomUuid = roomRepository.getRoomId(requestDto.getUuid());
        if (roomViewer == null)
            roomViewerRepository.save(roomViewer.join(roomUuid, requestDto.getHostUuid(),false));
        responseDto.setRoomId(roomRepository.getRoomId(requestDto.getUuid()));
        responseDto.setCreatedAt(roomRepository.getCreatedAt(requestDto.getTitle()));

        return Optional.of(responseDto).orElseThrow(()-> new CustomRoomException(ErrorCode.L002));
    }
}
