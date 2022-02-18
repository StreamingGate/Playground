package com.example.mainservice.service;

import com.example.mainservice.dto.*;
import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Room.Room;
import com.example.mainservice.entity.Room.RoomRepository;
import com.example.mainservice.entity.RoomViewer.RoomViewer;
import com.example.mainservice.entity.RoomViewer.RoomViewerRepository;
import com.example.mainservice.entity.Notification.NotificationRepository;
import com.example.mainservice.entity.User.User;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.Video.VideoRepository;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.entity.ViewdHistory.ViewedRepository;
import com.example.mainservice.exceptionhandler.customexception.CustomMainException;
import com.example.mainservice.exceptionhandler.customexception.ErrorCode;
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
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final ViewedRepository viewedRepository;
    private final RoomViewerRepository liveRoomViewerRepository;
    private final NotificationRepository notificationRepository;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    public HomeListDto getHomeList(Category category, long lastVideoId, long lastLiveRoomId, int size) throws Exception{
        List<VideoResponseDto> videoDtos = getVideoList(category, lastVideoId, size);
        List<RoomResponseDto> roomDtos = getLiveRoomList(category, lastLiveRoomId, size);
        HomeListDto homeListDto = new HomeListDto(videoDtos, roomDtos);
        return homeListDto;
    }

    private List<VideoResponseDto> getVideoList(Category category, long lastId, int size) throws Exception{
        Stream<Video> videoDtoStream = null;
        Pageable pageable = PageRequest.of(0, size);
        if (category == Category.ALL) {
            if(lastId == -1) videoDtoStream = videoRepository.findAll(pageable).getContent().stream();
            else  videoDtoStream = videoRepository.findAll(lastId, pageable).getContent().stream();
        } else {
            if(lastId == -1) videoDtoStream = videoRepository.findAllByCategory(category, pageable).stream();
            else videoDtoStream = videoRepository.findAllByCategory(category, lastId, pageable).stream();
        }
        return videoDtoStream.map(VideoResponseDto::new)
                .collect(Collectors.toList());
    }

    public List<RoomResponseDto> getLiveRoomList(Category category, long lastId, int size) throws Exception{
        Pageable pageable = PageRequest.of(0, size);
        Stream<Room> liveRoomDtoStream = null;
        if (category == Category.ALL) {
            if(lastId == -1) liveRoomDtoStream = roomRepository.findAll(pageable).getContent().stream();
            else liveRoomDtoStream = roomRepository.findAll(lastId, pageable).getContent().stream();
        } else {
            if(lastId == -1) liveRoomDtoStream = roomRepository.findAllByCategory(category, pageable).stream();
            else liveRoomDtoStream = roomRepository.findAllByCategory(category, lastId, pageable).stream();
        }
        return liveRoomDtoStream.map(RoomResponseDto::new)
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

    @Transactional
    public void actionToVideo(VideoActionDto dto, boolean isCancel) throws Exception {
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
            if (isCancel) viewedHistory.setLiked(false);
            else viewedHistory.setLiked(true);
//                notificationRepository.save(Notification.createLikes(user, video)); /* TODO push알림으로 수정하기 */
        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel) viewedHistory.setDisliked(false);
            else viewedHistory.setDisliked(true);
        }
    }

    @Transactional
    public void actionToLiveRoom(VideoActionDto dto, boolean isCancel) throws Exception {
        RoomViewer roomViewer = liveRoomViewerRepository.findByLiveRoomIdAndUserUuid(dto.getUuid(), dto.getId())
                .orElse(null);
        User user = userRepository.findByUuid(dto.getUuid()).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        if (roomViewer == null) {
            user = userRepository.findByUuid(dto.getUuid())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.U002));
            Room room = roomRepository.findById(dto.getId())
                    .orElseThrow(() -> new CustomMainException(ErrorCode.L001));
            roomViewer = new RoomViewer(user, room);
            liveRoomViewerRepository.save(roomViewer);
        }
        Room room = roomViewer.getRoom();
        if (dto.getAction() == VideoActionDto.ACTION.REPORT) {
            room.addReportCnt(1);
        } else if (dto.getAction() == VideoActionDto.ACTION.LIKE) {
            if (isCancel) roomViewer.setLiked(false);
            else roomViewer.setLiked(true);
//                notificationRepository.save(Notification.createLikes(user, video)); /* TODO push알림으로 수정하기 */
        } else if (dto.getAction() == VideoActionDto.ACTION.DISLIKE) {
            if (isCancel)  roomViewer.setDisliked(false);
            else roomViewer.setDisliked(true);
        }
    }

}
