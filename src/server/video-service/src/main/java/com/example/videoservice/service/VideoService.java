package com.example.videoservice.service;

import com.example.videoservice.dto.VideoResponseDto;
import com.example.videoservice.entity.User.User;
import com.example.videoservice.entity.User.UserRepository;
import com.example.videoservice.entity.Video.Video;
import com.example.videoservice.entity.Video.VideoRepository;
import com.example.videoservice.entity.ViewdHistory.ViewedHistory;
import com.example.videoservice.entity.ViewdHistory.ViewedRepository;
import com.example.videoservice.exceptionHandler.customexception.CustomVideoException;
import com.example.videoservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class VideoService {

    private final UserRepository userRepository;
    private final VideoRepository videoRepository;
    private final ViewedRepository viewedRepository;

    /**
     * 시청기록이 존재하면 가져오고, 없으면 새로 저장한다.(조회수 증가)
     */
    @Transactional
    public VideoResponseDto getVideo(Long videoId, String uuid) throws CustomVideoException{
        Optional<ViewedHistory> viewedHistory = viewedRepository.findByVideoIdAndUserUuid(uuid, videoId);
        VideoResponseDto result = null;

        if(viewedHistory.isPresent()){
            Video video = viewedHistory.get().getVideo();
            video.addHits();
            result = new VideoResponseDto(video, video.getMetadata().getFileLink(), viewedHistory.get());
        }
        else{
            User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomVideoException(ErrorCode.U002));
            Video video = videoRepository.findById(videoId).orElseThrow(() -> new CustomVideoException(ErrorCode.V001));
            video.addHits();
            ViewedHistory newViewedHistory  = new ViewedHistory(user, video);
            viewedRepository.save(newViewedHistory);
            result = new VideoResponseDto(video, video.getMetadata().getFileLink(), newViewedHistory);
        }

        return result;
    }
}
