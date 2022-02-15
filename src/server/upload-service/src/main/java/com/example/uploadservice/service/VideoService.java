package com.example.uploadservice.service;

import com.example.uploadservice.dto.VideoDto;
import com.example.uploadservice.entity.Metadata.Metadata;
import com.example.uploadservice.entity.Metadata.MetadataRepository;
import com.example.uploadservice.entity.Room.Room;
import com.example.uploadservice.entity.Room.RoomRepository;
import com.example.uploadservice.entity.RoomViewer.RoomViewerRepository;
import com.example.uploadservice.entity.User.User;
import com.example.uploadservice.entity.User.UserRepository;
import com.example.uploadservice.entity.Video.Video;
import com.example.uploadservice.entity.Video.VideoRepository;
import com.example.uploadservice.entity.ViewdHistory.ViewedHistory;
import com.example.uploadservice.entity.ViewdHistory.ViewedRepository;
import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import com.example.uploadservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.AsyncRestTemplate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class VideoService {

    private static final String DEFAULT_M3U8_FILE = "video.m3u8";
    private static final String DEFAULT_VIDEO_FILE = "video.mp4";
    private final VideoRepository videoRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final RoomViewerRepository roomViewerRepository;
    private final ViewedRepository viewedRepository;
    private final MetadataRepository metadataRepository;

    @Transactional
    public Video add(VideoDto dto){
        User user = userRepository.findByUuid(dto.getUploaderUuid())
                .orElseThrow(() -> new CustomUploadException(ErrorCode.U002));
        Metadata metadata = Metadata.builder()
                .fileLink(dto.getS3OutputPath() + "/" + DEFAULT_M3U8_FILE)
                .fileName(DEFAULT_VIDEO_FILE)
                .size(dto.getSize())
                .uploaderEmail(user.getEmail())
                .videoCreatedAt(dto.getVideoCreatedAt())
                .build();
        Video video = Video.builder()
                .title(dto.getTitle())
                .content(dto.getContent())
                .category(dto.getCategory())
                .uuid(dto.getVideoUuid())
                .thumbnail(dto.getS3OutputPath() + "/" + dto.getThumbnailName())
                .user(user)
                .build();

        createChatRoom(video.getUuid());

        metadataRepository.save(metadata);
        video.setMetadata(metadata);
        return videoRepository.save(video);
    }

    @Transactional
    public void remove(Video video, Long roomId) throws CustomUploadException{
        Room room = roomRepository.findById(roomId).orElseThrow(() -> new CustomUploadException(ErrorCode.L001));
        if(room.getRoomViewers() != null) {
            List<ViewedHistory> viewedHistories = room.getRoomViewers()
                    .stream()
                    .map(roomViewer -> new ViewedHistory(roomViewer, video))
                    .collect(Collectors.toList());
            viewedRepository.saveAll(viewedHistories);
            roomViewerRepository.deleteAll(room.getRoomViewers());
        }

        roomRepository.delete(room);
    }

    private void createChatRoom(String uuid){
        AsyncRestTemplate asyncRestTemplate = new AsyncRestTemplate();
        HttpEntity<?> requestDto = new HttpEntity<>(Map.of("uuid", uuid));
        asyncRestTemplate.postForEntity("http://localhost:8888/chat/room",
                requestDto, String.class);
        log.info("create chat room 요청 완료");
    }
}
