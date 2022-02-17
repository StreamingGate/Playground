package com.example.roomservice.service;

import com.example.roomservice.dto.RequestDto;
import com.example.roomservice.dto.RequestExitDto;
import com.example.roomservice.dto.ResponseDto;
import com.example.roomservice.dto.ResponseExitDto;
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
        Room room = roomRepository.findById(roomId).orElseThrow(() -> new CustomRoomException(ErrorCode.L001));
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomRoomException(ErrorCode.U002));
        RoomViewer roomViewer = roomViewerRepository.findByUserUuidAndRoomUuid(uuid,roomId);
        ResponseDto responseDto = mapper.map(room,ResponseDto.class);
        if (roomViewer == null) {
            roomViewerRepository.save(roomViewer.join(roomId, uuid,room,user,false,false));
            responseDto.setLiked(false);
            responseDto.setDisliked(false);
        }
        else {
            roomViewer.join(roomId,uuid,room,user,roomViewer.getLiked(),roomViewer.getDisliked());
            responseDto.setLiked(roomViewer.getLiked());
            responseDto.setDisliked(roomViewer.getDisliked());
        }
        responseDto.setHostNickname(user.getNickName());
        responseDto.setRoomId(roomId);
        responseDto.setLastViewedAt(LocalDateTime.now());
        return Optional.of(responseDto).orElseThrow(()->new CustomRoomException(ErrorCode.L001));
    }

    @Transactional
    public ResponseDto create(RequestDto requestDto) throws CustomRoomException {
        User user = userRepository.findByUuid(requestDto.getHostUuid()).orElseThrow(() -> new CustomRoomException(ErrorCode.U002));
        ResponseDto responseDto = mapper.map(requestDto,ResponseDto.class);
        String uploadThumbnail = amazonS3Service.upload(requestDto.getThumbnail(),requestDto.getUuid());
        requestDto.setThumbnail(uploadThumbnail);
        Room room = Room.create(requestDto,user);
        roomRepository.save(room);
        Long roomUuid = roomRepository.getRoomId(requestDto.getUuid());
        roomViewerRepository.save(RoomViewer.join(roomUuid, requestDto.getHostUuid(),room,user,false,false));
        responseDto.setRoomId(roomRepository.getRoomId(requestDto.getUuid()));
        responseDto.setThumbnail(uploadThumbnail);
        responseDto.setLiked(false);
        responseDto.setDisliked(false);
        return Optional.of(responseDto).orElseThrow(()-> new CustomRoomException(ErrorCode.L002));
    }

    @Transactional
    public String check(String uuid) throws CustomRoomException {
        Room room = roomRepository.findByUuid(uuid);
        if(room != null) return room.getUuid();
        throw new CustomRoomException(ErrorCode.L002);
    }

    @Transactional
    public ResponseExitDto delete(RequestExitDto requestExitDto) throws CustomRoomException {
        Room room = roomRepository.findByUuid(requestExitDto.getUuid());
        if (room != null) {
            roomRepository.delete(room);
            return mapper.map(room,ResponseExitDto.class);
        }
        throw new CustomRoomException(ErrorCode.L001);
    }
}
