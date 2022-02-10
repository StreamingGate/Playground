package com.example.roomservice.service;

import com.example.roomservice.dto.RequestDto;
import com.example.roomservice.dto.ResponseDto;
import com.example.roomservice.entity.Room.Room;
import com.example.roomservice.entity.Room.RoomRepository;
import com.example.roomservice.entity.RoomViewer.RoomViewer;
import com.example.roomservice.entity.RoomViewer.RoomViewerRepository;
import com.example.roomservice.entity.User.User;
import com.example.roomservice.entity.User.UserRepository;
import com.example.roomservice.exceptionHandler.customexception.CustomRoomException;
import com.example.roomservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class RoomService {
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final ModelMapper mapper;
    private final AmazonS3Service amazonS3Service;
    private final RoomViewerRepository roomViewerRepository;

    @Transactional
    public ResponseDto join(Long roomId, String uuid) throws CustomRoomException {
        Room room = roomRepository.getById(roomId);
        RoomViewer roomViewer = roomViewerRepository.findByUserUuidAndRoomUuid(uuid,roomId);
        ResponseDto responseDto = mapper.map(room,ResponseDto.class);
        if (roomViewer == null) {
            roomViewerRepository.save(roomViewer.join(roomId, uuid,false,false));
            responseDto.setLiked(false);
            responseDto.setDisliked(false);
        }
        else {
            roomViewer.join(roomId,uuid,roomViewer.getLiked(),roomViewer.getDisliked());
            responseDto.setLiked(roomViewer.getLiked());
            responseDto.setDisliked(roomViewer.getDisliked());
        }
        responseDto.setRoomId(roomId);
        return Optional.of(responseDto).orElseThrow(()->new CustomRoomException(ErrorCode.L001));
    }

    @Transactional
    public ResponseDto create(RequestDto requestDto) throws CustomRoomException {
        User user = userRepository.findByUuid(requestDto.getHostUuid()).orElseThrow(() -> new CustomRoomException(ErrorCode.U002));
        roomRepository.save(Room.create(requestDto,user));
        ResponseDto responseDto = mapper.map(requestDto,ResponseDto.class);
        responseDto.setThumbnail(amazonS3Service.upload(requestDto.getThumbnail(),requestDto.getUuid()));
        Long roomUuid = roomRepository.getRoomId(requestDto.getUuid());
        roomViewerRepository.save(RoomViewer.join(roomUuid, requestDto.getHostUuid(),false,false));
        responseDto.setRoomId(roomRepository.getRoomId(requestDto.getUuid()));
        responseDto.setCreatedAt(roomRepository.getCreatedAt(requestDto.getTitle()));
        responseDto.setLiked(false);
        responseDto.setDisliked(false);
        return Optional.of(responseDto).orElseThrow(()-> new CustomRoomException(ErrorCode.L002));
    }

    @Transactional
    public String check(String uuid) throws CustomRoomException {
        return Optional.of(roomRepository.findByUuid(uuid).get().getUuid()).orElseThrow(() -> new CustomRoomException(ErrorCode.L002));
    }

//    @Transactional
//    public
}
