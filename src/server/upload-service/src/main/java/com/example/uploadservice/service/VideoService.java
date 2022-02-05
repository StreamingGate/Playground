package com.example.uploadservice.service;

import com.example.uploadservice.dto.VideoDto;
import com.example.uploadservice.entity.Metadata.Metadata;
import com.example.uploadservice.entity.Metadata.MetadataRepository;
import com.example.uploadservice.entity.User.User;
import com.example.uploadservice.entity.User.UserRepository;
import com.example.uploadservice.entity.Video.Video;
import com.example.uploadservice.entity.Video.VideoRepository;
import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import com.example.uploadservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class VideoService {

    private static final String DEFAULT_M3U8_FILE = "video.m3u8";
    private static final String DEFAULT_VIDEO_FILE = "video.mp4";
    private static final String DEFAULT_THUMBNAIL_FILE = "thumbnail.png";
    private final VideoRepository videoRepository;
    private final UserRepository userRepository;
    private final MetadataRepository metadataRepository;

    @Transactional
    public void add(VideoDto dto){
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
                .thumbnail(dto.getS3OutputPath() + "/" + DEFAULT_THUMBNAIL_FILE)
                .user(user)
                .build();

        metadataRepository.save(metadata);
        videoRepository.save(video);
        video.setMetadata(metadata);
    }
}
