package com.example.mainservice.service;

import com.example.mainservice.dto.*;
import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Live.Live;
import com.example.mainservice.entity.Live.LiveRepository;
import com.example.mainservice.entity.LiveViewer.LiveViewer;
import com.example.mainservice.entity.LiveViewer.LiveViewerRepository;
import com.example.mainservice.entity.Notification.Notification;
import com.example.mainservice.entity.Notification.NotificationRepository;
import com.example.mainservice.entity.User.User;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@RequiredArgsConstructor
@Service
public class MainService {

    private static final String RESPONSE_SUCCESS = "success";
    private final VideoRepository videoRepository;
    private final LiveRepository liveRepository;
    private final UserRepository userRepository;
    private final ViewedRepository viewedRepository;
    private final LiveViewerRepository liveViewerRepository;
    private final NotificationRepository notificationRepository;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    public VideoListDto getHomeList(Category category, long lastVideoId, long lastLiveRoomId, int size) throws Exception{
        List<VideoDto> videoDtos = getVideoList(category, lastVideoId, size);
        List<LiveRoomDto> liveRoomDtos = getLiveRoomList(category, lastLiveRoomId, size);
        VideoListDto videoListDto = new VideoListDto(videoDtos, liveRoomDtos);
        return videoListDto;
    }

    private List<VideoDto> getVideoList(Category category, long lastId, int size) throws Exception{
        Stream<Video> videoDtoStream = null;
        Pageable pageable = PageRequest.of(0, size);
        if (category == Category.ALL) {
            if(lastId == -1){
                videoDtoStream = videoRepository.findAll(pageable).getContent().stream();
            }
            else {
                videoDtoStream = videoRepository.findAll(lastId, pageable).getContent().stream();
            }
        } else {
            if(lastId == -1){
                videoDtoStream = videoRepository.findAllByCategory(category, pageable).stream();
            }
            else {
                videoDtoStream = videoRepository.findAllByCategory(category, lastId, pageable).stream();
            }
        }
        return videoDtoStream.map(video -> VideoDto.fromEntity(mapper, video))
                .collect(Collectors.toList());
    }

    public List<LiveRoomDto> getLiveRoomList(Category category, long lastId, int size) throws Exception{
        Pageable pageable = PageRequest.of(0, size);
        Stream<Live> liveRoomDtoStream = null;
        if (category == Category.ALL) {
            if(lastId == -1){
                liveRoomDtoStream = liveRepository.findAll(pageable).getContent().stream();
            }
            else {
                liveRoomDtoStream = liveRepository.findAll(lastId, pageable).getContent().stream();
            }
        } else {
            if(lastId == -1){
                liveRoomDtoStream = liveRepository.findAllByCategory(category, pageable).stream();
            }
            else {
                liveRoomDtoStream = liveRepository.findAllByCategory(category, lastId, pageable).stream();
            }
        }
        return liveRoomDtoStream.map(liveRoom -> LiveRoomDto.fromEntity(mapper, liveRoom))
                .collect(Collectors.toList());
    }
    @Transactional(readOnly = true)
    public List<NotificationDto> getNotificationList(String uuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
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

    /* TODO : elastic search로 구현 */
//    @Transactional(readOnly = true)
//    public SearchedList searchVideoByKeyword(String keyword, int page, int size) throws Exception {
//        return null;
//    }

    private void actionToVideo(VideoActionDto dto, boolean isCancel) throws Exception {
        ViewedHistory viewedHistory = viewedRepository.findByVideoIdAndUserUuid(dto.getUuid(), dto.getId()).orElse(null);
        User user = userRepository.findByUuid(dto.getUuid()).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        if (viewedHistory == null) { //봤지만 처음 저장하는 경우
            user = userRepository.findByUuid(dto.getUuid())
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
                notificationRepository.save(Notification.createLikes(user, video)); /* TODO push알림으로 수정하기 */
            }
        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel) viewedHistory.setDisliked(false);
            else viewedHistory.setDisliked(true);
        }
    }

    private void actionToLiveRoom(VideoActionDto dto, boolean isCancel) throws Exception {
        LiveViewer liveViewer = liveViewerRepository.findByLiveRoomIdAndUserUuid(dto.getUuid(), dto.getId())
                .orElse(null);
        User user = userRepository.findByUuid(dto.getUuid()).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        if (liveViewer == null) {
            user = userRepository.findByUuid(dto.getUuid())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.U002));
            Live live = liveRepository.findById(dto.getId())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.L001));
            liveViewer = new LiveViewer(user, live);
            liveViewerRepository.save(liveViewer);
        }
        Live live = liveViewer.getLive();
        if (dto.getAction() == VideoActionDto.ACTION.REPORT) {
            live.addReportCnt(1);
        } else if (dto.getAction() == VideoActionDto.ACTION.LIKE) {
            if (isCancel) {
                liveViewer.setLiked(false);
                live.addLikeCnt(-1);
            } else {
                liveViewer.setLiked(true);
                live.addLikeCnt(1);

            }
        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel) liveViewer.setDisliked(false);
            else liveViewer.setDisliked(true);
        }
    }
}
