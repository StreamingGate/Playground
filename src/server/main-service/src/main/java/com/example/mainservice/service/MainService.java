package com.example.mainservice.service;

import com.example.mainservice.dto.*;
import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.LiveRoom.LiveRoomRepository;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.LiveViewer.LiveViewerRepository;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.Video.VideoRepository;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.entity.ViewdHistory.ViewedRepository;
import com.example.mainservice.exceptionHandler.customexception.CustomMainException;
import com.example.mainservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class MainService {

    private static final String RESPONSE_SUCCESS = "success";
    private final VideoRepository videoRepository;
    private final LiveRoomRepository liveRoomRepository;
    private final UserRepository userRepository;
    private final ViewedRepository viewedRepository;
    private final LiveViewerRepository liveViewerRepository;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    public HomeList getVideoList(Category category, int page, int size) {
        List<VideoDto> videoDtos = null;
        List<LiveRoomDto> liveRoomDtos = null;
        Pageable pageable = PageRequest.of(page, size);
        if (category == Category.ALL) {
            videoDtos = videoRepository.findAll(pageable).getContent().stream()
                    .map(video -> mapper.map(video, VideoDto.class))
                    .collect(Collectors.toList());
            liveRoomDtos = liveRoomRepository.findAll(pageable).getContent().stream()
                    .map(liveRoom -> mapper.map(liveRoom, LiveRoomDto.class))
                    .collect(Collectors.toList());
        } else {
            videoDtos = videoRepository.findAllByCategory(category, pageable).stream()
                    .map(video -> mapper.map(video, VideoDto.class))
                    .collect(Collectors.toList());
            liveRoomDtos = liveRoomRepository.findAllByCategory(category, pageable).stream()
                    .map(liveRoom -> mapper.map(liveRoom, LiveRoomDto.class))
                    .collect(Collectors.toList());
        }
        HomeList homeList = new HomeList(videoDtos, liveRoomDtos); /* TODO: 내부 필드 List로 응답되는지 검증 필요 */
        return homeList;
    }

    @Transactional(readOnly = true)
    public List<NotificationDto> getNotificationList(String uuid) throws Exception {
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        List<NotificationDto> notificationDtos = user.getNotifications().stream()
                .map(notification -> mapper.map(notification, NotificationDto.class))
                .collect(Collectors.toList());
        return notificationDtos;

    }

    @Transactional
    public String action(VideoActionDto dto) throws Exception {
        if (dto.getType() == 0) actionToVideo(dto, false);
        else actionToLiveRoom(dto, false);
        return RESPONSE_SUCCESS;
    }

    @Transactional
    public String cancelAction(VideoActionDto dto) throws Exception {
        if (dto.getType() == 0) actionToVideo(dto, true);
        else actionToLiveRoom(dto, true);
        return RESPONSE_SUCCESS;
    }

    @Transactional(readOnly = true)
    public SearchedList searchVideoByKeyword(String keyword, Category category, int page, int size) throws Exception {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        List<Video> videos = videoRepository.findAllByCategory(category, pageable);
        List<LiveRoom> liveRooms = liveRoomRepository.findAllByCategory(category, pageable);
        return new SearchedList(videos, liveRooms); /* TODO: 내부 필드 List로 응답되는지 검증 필요 */
    }

    private void actionToVideo(VideoActionDto dto, boolean isCancel) throws Exception {
        ViewedHistory viewedHistory = viewedRepository.findByVideoIdAndUserUuid(dto.getUuid(), dto.getId()).orElse(null);
        if (viewedHistory == null) { //봤지만 처음 저장하는 경우
            UserEntity user = userRepository.findByUuid(dto.getUuid())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.U002));
            Video video = videoRepository.findById(dto.getId())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.V001));
            viewedHistory = new ViewedHistory(user, video);
            viewedRepository.save(viewedHistory);
        }
        Video video = viewedHistory.getVideo();

        if (dto.getAction() == VideoActionDto.ACTION.REPORT) {
            video.addReportCnt(1);
        } else if (dto.getAction() == VideoActionDto.ACTION.LIKE) {
            if (isCancel) {
                viewedHistory.setLiked(false);
                video.addLikeCnt(-1);
            } else {
                viewedHistory.setLiked(true);
                video.addLikeCnt(1);
            }

        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel) viewedHistory.setDisliked(false);
            else viewedHistory.setDisliked(true);
        }
    }

    private void actionToLiveRoom(VideoActionDto dto, boolean isCancel) throws Exception {
        LiveViewer liveViewer = liveViewerRepository.findByLiveRoomIdAndUserUuid(dto.getUuid(), dto.getId())
                .orElse(null);
        if (liveViewer == null) {
            UserEntity user = userRepository.findByUuid(dto.getUuid())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.U002));
            LiveRoom liveRoom = liveRoomRepository.findById(dto.getId())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.L001));
            liveViewer = new LiveViewer(user, liveRoom);
            liveViewerRepository.save(liveViewer);
        }
        LiveRoom liveRoom = liveViewer.getLiveRoom();
        if (dto.getAction() == VideoActionDto.ACTION.REPORT) {
            liveRoom.addReportCnt(1);
        } else if (dto.getAction() == VideoActionDto.ACTION.LIKE) {
            if (isCancel) {
                liveViewer.setLiked(false);
                liveRoom.addLikeCnt(-1);
            } else {
                liveViewer.setLiked(true);
                liveRoom.addLikeCnt(1);
            }
        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel) liveViewer.setDisliked(false);
            else liveViewer.setDisliked(true);
        }
    }
}
