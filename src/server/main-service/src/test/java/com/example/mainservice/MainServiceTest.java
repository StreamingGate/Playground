package com.example.mainservice;

import com.example.mainservice.dto.HomeListDto;
import com.example.mainservice.dto.VideoActionDto;
import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Notification.NotificationRepository;
import com.example.mainservice.entity.Room.Room;
import com.example.mainservice.entity.Room.RoomRepository;
import com.example.mainservice.entity.RoomViewer.RoomViewerRepository;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.Video.VideoRepository;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.entity.ViewdHistory.ViewedRepository;
import com.example.mainservice.service.MainService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.modelmapper.ModelMapper;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;

@Slf4j
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@ExtendWith(SpringExtension.class)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@DataJpaTest //JPA 관련 테스트 설정만 로드.
public class MainServiceTest {

    private static final String[] USER_UUID = new String[]{
            "",
            "11111111-1234-1234-123456789012",
            "22222222-1234-1234-123456789012",
            "33333333-1234-1234-123456789012",
            "44444444-1234-1234-123456789012"
    };
    @SpyBean
    private VideoRepository videoRepository;
    @SpyBean
    private  RoomRepository roomRepository;
    @SpyBean
    private UserRepository userRepository;
    @SpyBean
    private  ViewedRepository viewedRepository;
    @SpyBean
    private RoomViewerRepository roomViewerRepository;
    @SpyBean
    private NotificationRepository notificationRepository;
    @InjectMocks
    private MainService mainService;

    @BeforeAll
    public void setUp(){
        mainService = new MainService(videoRepository, roomRepository, userRepository,
                viewedRepository, roomViewerRepository, notificationRepository, new ModelMapper());
    }

    @DisplayName("카테고리별 영상 리스트 조회에서 최신순 페이지네이션으로 첫 페이지 정상 조회")
    @Test
    public void paginationHomeList() throws Exception{
        //given
        final long LAST_VIDEO_ID = 5;
        final long LAST_ROOM_ID = 5;
        final int SIZE = 2;
        final Pageable PAGEABLE = PageRequest.of(0, SIZE);
        List<Video> fakeVideoList = createVideoList(2);
        List<Room> fakeRoomList = createRoomList(2);

        //mocking
        given(videoRepository.findAllByCategory(Category.EDU, PAGEABLE)).willReturn(fakeVideoList);
        given(roomRepository.findAllByCategory(Category.EDU, PAGEABLE)).willReturn(fakeRoomList);

        //when
        HomeListDto findHomeList = mainService.getHomeList(Category.ALL, LAST_VIDEO_ID, LAST_ROOM_ID, SIZE);

        //then
        assertThat(findHomeList.getVideos().size()).isEqualTo(SIZE);
        assertThat(findHomeList.getVideos().size()).isEqualTo(SIZE);
    }

    @DisplayName("Video에 좋아요 누르면 ViewedHistory에 기록됨")
    @Test
    public void findByVideoActionDto() throws Exception {
        //given
        final Long VIDEO_ID = 1l;
        VideoActionDto dto = VideoActionDto.builder().id(VIDEO_ID)
                .uuid(USER_UUID[1])
                .action(VideoActionDto.ACTION.LIKE)
                .type(0) //video
                .build();
        ViewedHistory fakeViewedHistory = createViewedHistory(true, false, LocalDateTime.now());
        //mocking
        given(viewedRepository.findByVideoIdAndUserUuid(USER_UUID[1],VIDEO_ID))
                .willReturn(Optional.of(fakeViewedHistory));

        //when
        mainService.action(dto);

        //then
        ViewedHistory vh = viewedRepository.findByVideoIdAndUserUuid(dto.getUuid(), dto.getId()).get();
        assertThat(vh.getLikedAt()).isNotNull();
        assertThat(vh.isLiked()).isEqualTo(true);
        assertThat(vh.isDisliked()).isEqualTo(false);
    }

    private ViewedHistory createViewedHistory( boolean liked, boolean disliked, LocalDateTime likedAt){
        return new ViewedHistory(liked, disliked, likedAt);
    }

    private List<Video> createVideoList(int cnt){
        //given
        List<Video> list = new LinkedList<>();
        for(long i=100;i<=100+cnt;i++) {
            list.add(new Video(i));
        }
        return list;
    }

    private List<Room> createRoomList(int cnt){
        //given
        List<Room> list = new LinkedList<>();
        for(long i=100;i<=100+cnt;i++) {
            list.add(new Room(i));
        }
        return list;
    }
}
