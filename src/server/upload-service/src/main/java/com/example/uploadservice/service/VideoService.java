package com.example.uploadservice.service;

import com.example.uploadservice.dto.UploadRequestDto;
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

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Service
public class VideoService {

    private final VideoRepository videoRepository;
    private final UserRepository userRepository;
    private final MetadataRepository metadataRepository;

    @Transactional
    public void add(UploadRequestDto dto, String thumbnailPath, String videoPath,
                    Long size, LocalDateTime videoCreatedAt){
        User user = userRepository.findByNickName(dto.getUploaderNickname())
                .orElseThrow(() -> new CustomUploadException(ErrorCode.U002));
        Metadata metadata = Metadata.builder()
                .fileLink(videoPath)
                .fileName(videoPath) // video.id
                .size(size)
                .uploaderEmail(user.getEmail())
                .videoCreatedAt(videoCreatedAt)
                .build();
        Video video = Video.builder()
                .title(dto.getTitle())
                .content(dto.getContent())
                .category(dto.getCategory())
                .uploaderNickname(user.getNickName())
                .thumbnail(thumbnailPath)
                .user(user)
                .build();
        video.setMetadata(metadata);
        metadataRepository.save(metadata);
        videoRepository.save(video);
    }

    /**
     * save Video and Metadata
     */
    @Transactional
    public Long add(UploadRequestDto dto){
        User user = userRepository.findByNickName(dto.getUploaderNickname())
                .orElseThrow(() -> new CustomUploadException(ErrorCode.U002));

        Video video = Video.builder()
                .title(dto.getTitle())
                .content(dto.getContent())
                .category(dto.getCategory())
                .uploaderNickname(user.getNickName())
                .user(user)
                .build();
        return videoRepository.save(video).getId();
    }

    @Transactional
    public void updateThumbnail(Long id, String path){
        Video video = videoRepository.findById(id).orElseThrow(() -> new CustomUploadException(ErrorCode.V001));
        video.setThumbnail(path);
    }

}
