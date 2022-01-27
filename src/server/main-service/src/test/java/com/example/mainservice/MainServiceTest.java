package com.example.mainservice;

import com.example.mainservice.dto.VideoActionDto;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.LiveRoom.LiveRoomRepository;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.entity.Video.Video;
import com.example.mainservice.entity.Video.VideoRepository;
import com.example.mainservice.entity.ViewdHistory.ViewedHistory;
import com.example.mainservice.entity.ViewdHistory.ViewedRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import static org.assertj.core.api.Assertions.assertThat;

@Slf4j
@ExtendWith(SpringExtension.class)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@DataJpaTest
public class MainServiceTest {

    @Autowired
    private VideoRepository videoRepository;

    @Autowired
    private  ViewedRepository viewedRepository;

    @Autowired
    private UserRepository userRepository;


    @DisplayName("findAll: 최신순 페이지네이션으로 첫 페이지 정상 조회")
    @Test
    public void paginationByCreatedAtDesc() {
        //given
        final int PAGE = 2;
        final int SIZE = 2;
        final String VIDEO_NAME_LAST = "video1";
        videoRepository.findAll().stream().forEach(video -> log.info(video.getTitle()+" " + video.getCreatedAt()));

        //when
        Pageable pageable = PageRequest.of(PAGE, SIZE);
        Page<Video> videos = videoRepository.findAll(pageable);
        //then
        assertThat(videos.getSize()).isEqualTo(SIZE);
        assertThat(videos.getContent().get(0).getTitle()).isEqualTo(VIDEO_NAME_LAST);
    }

    @DisplayName("findByVideoIdAndUserUuid: uuid로 ViewedHistory에서 시청한 여부 정상 조회")
    @Test
    public void findByVideoActionDto() {
        //given
        VideoActionDto dto = VideoActionDto.builder().id(1)
                .uuid("11111111-1234-1234-123456789012")
                .action(VideoActionDto.ACTION.LIKE)
                .type(0)
                .build();
        //when
        ViewedHistory vh = viewedRepository.findByVideoIdAndUserUuid(dto.getUuid(), dto.getId()).get();
        UserEntity user = userRepository.findByUuid(dto.getUuid()).get();
        //then
        assertThat(vh).isNotNull();
        assertThat(user).isNotNull();
        assertThat(vh.getUserEntity()).isSameAs(user);
    }

    @DisplayName("findAllByCategory: ")
    @Test
    public void findAllByCategory() {

    }

}
