package com.example.mainservice;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.FriendWait.FriendWaitRepository;
import com.example.mainservice.entity.Notification.NotificationRepository;
import com.example.mainservice.entity.User.User;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.exceptionhandler.customexception.CustomMainException;
import com.example.mainservice.service.FriendService;
import com.example.mainservice.utils.HttpRequest;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.modelmapper.ModelMapper;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import java.util.List;
import java.util.Optional;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@Slf4j
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@ExtendWith(MockitoExtension.class)
@DataJpaTest //JPA 관련 테스트 설정만 로드.
public class FriendServiceTest {

    private static final String[] USER_UUID = new String[]{
            "",
            "11111111-1234-1234-123456789012",
            "22222222-1234-1234-123456789012",
            "33333333-1234-1234-123456789012",
            "44444444-1234-1234-123456789012"
    };

    @SpyBean
    private UserRepository userRepository;

    @SpyBean
    private FriendWaitRepository friendWaitRepository;

    @SpyBean
    private NotificationRepository notificationRepository;

    @InjectMocks
    private FriendService friendService;

    @BeforeAll
    public void setUp(){
        friendService = new FriendService(userRepository, friendWaitRepository, notificationRepository, new ModelMapper());
    }

    // 더미데이터(data.sql)사용
    @DisplayName("1.친구 목록에서 친구인 유저만 조회 가능")
    @Test
    public void findFriendAll(){
        //given
        User user1 = userRepository.findById(1l).orElse(null);
        User user2 = userRepository.findById(2l).orElse(null);
        User user3 = userRepository.findById(3l).orElse(null);
        User user4 = userRepository.findById(4l).orElse(null);

        //when
        assertThat(user1).isNotNull();
        assertThat(user2).isNotNull();
        assertThat(user3).isNotNull();
        assertThat(user4).isNotNull();
        List<User> friends1 = user1.getFriends();
        List<User> friends2 = user2.getFriends();
        List<User> friends3 = user3.getFriends();
        List<User> friends4 = user4.getFriends();

        //then
        assertThat(friends1.contains(user3)).isEqualTo(true);
        assertThat(friends2.contains(user4)).isEqualTo(true);
        assertThat(friends3.contains(user1)).isEqualTo(true);
        assertThat(friends3.contains(user4)).isEqualTo(true);
        assertThat(friends4.contains(user2)).isEqualTo(true);
        assertThat(friends4.contains(user3)).isEqualTo(true);
    }

    // 더미데이터(data.sql)사용
    @DisplayName("2.친구가 아닌 유저는 친구목록에서 조회 불가능")
    @Test
    public void findFriendAllOnlyFriend(){
        //given
        User user1 = userRepository.findById(1l).orElse(null);
        User user2 = userRepository.findById(2l).orElse(null);
        User user3 = userRepository.findById(3l).orElse(null);
        User user4 = userRepository.findById(4l).orElse(null);

        //when
        assertThat(user1).isNotNull();
        assertThat(user2).isNotNull();
        assertThat(user3).isNotNull();
        assertThat(user4).isNotNull();
        List<User> friends1 = user1.getFriends();
        List<User> friends2 = user2.getFriends();
        List<User> friends3 = user3.getFriends();
        List<User> friends4 = user4.getFriends();

        //then
        assertThat(friends1.contains(user2)).isEqualTo(false);
        assertThat(friends1.contains(user4)).isEqualTo(false);
        assertThat(friends2.contains(user1)).isEqualTo(false);
        assertThat(friends2.contains(user3)).isEqualTo(false);
        assertThat(friends3.contains(user2)).isEqualTo(false);
        assertThat(friends4.contains(user1)).isEqualTo(false);
    }

    @DisplayName("3.유저2가 유저3에게 친구 요청하면 유저3의 친구대기목록에 유저2가 추가됨")
    @Test
    public void test3() throws Exception{
        //given
        User user2 = createUser(2l);
        User user3 = createUser(3l);
        User fakeUser3 = createFriendRequestedUser(user2, 3l);

        //mocking
        given(userRepository.findByUuid(USER_UUID[2])).willReturn(Optional.of(user2));
        given(userRepository.findByUuid(USER_UUID[3])).willReturn(Optional.of(user3));
        given(userRepository.findById(3l)).willReturn(Optional.of(fakeUser3));

        //when
        friendService.requestFriend(user2.getUuid(), user3.getUuid());

        //then
        User requestedUser = userRepository.findById(3l).get();
        assertThat(requestedUser.getFriendWaits().size()).isEqualTo(1);
        assertThat(requestedUser.getFriendWaits().get(0).getSenderUuid()).isEqualTo(user2.getUuid());
    }

    @DisplayName("4.유저3이 유저2에게서 온 친구요청 수락하면 유저2,3의 친구목록에 서로 추가, 유저3 대기목록에서 유저2 삭제됨")
    @Test
    public void test4() throws Exception {
        //given
        User user2 = createUser(2l);
        User requestedUser3 = createFriendRequestedUser(user2, 3l);
        User[] fakeUsers = createFriends(2l, 3l);
        User fakeUser2 = fakeUsers[0];
        User fakeUser3 = fakeUsers[1];

        //mocking
        given(userRepository.findByUuid(USER_UUID[2])).willReturn(Optional.of(user2));
        given(userRepository.findByUuid(USER_UUID[3])).willReturn(Optional.of(requestedUser3));
        given(userRepository.findById(2l)).willReturn(Optional.of(fakeUser2));
        given(userRepository.findById(3l)).willReturn(Optional.of(fakeUser3));

        /* TODO HttpRequest.java(static void 메서드) mocking하는 법 알아내기 */
        //when
        try( MockedStatic<HttpRequest> mockedHttpRequest = mockStatic(HttpRequest.class) ) {
            mockedHttpRequest.when(() -> HttpRequest.sendAddFriend(any(), any())); // 채팅서버로의 요청은 생략한다.
            try{
                friendService.allowFriendRequest(requestedUser3.getUuid(), user2.getUuid());
            } catch (Exception e){
                e.printStackTrace();
            }
        }

        //then
        User findUser2 = userRepository.findById(2l).get();
        User findUser3 = userRepository.findById(3l).get();
        assertThat(findUser3.getFriendWaits().size()).isEqualTo(0);
        assertThat(findUser2.getFriends().contains(findUser3)).isEqualTo(true);
        assertThat(findUser3.getFriends().contains(findUser2)).isEqualTo(true);
    }

    @DisplayName("5.유저3이 유저2에게서 온 친구요청 거절하면 유저3 대기목록에서 유저2가 삭제됨")
    @Test
    public void test5() throws Exception {
        //given
        User user2 = createUser(2l);
        User requestedUser3 = createFriendRequestedUser(user2, 3l);
        User fakeUser3 = createUser(3l);

        //mocking
        given(userRepository.findByUuid(USER_UUID[2])).willReturn(Optional.of(user2));
        given(userRepository.findByUuid(USER_UUID[3])).willReturn(Optional.of(requestedUser3));
        given(userRepository.findById(3l)).willReturn(Optional.of(fakeUser3));

        //when
        friendService.refuseFriendRequest(requestedUser3.getUuid(), user2.getUuid());

        //then
        User findUser3 = userRepository.findById(3l).get();
        assertThat(fakeUser3.getFriendWaits().size()).isEqualTo(0);
        assertThat(findUser3.getFriends().contains(user2)).isEqualTo(false);
        assertThat(user2.getFriends().contains(findUser3)).isEqualTo(false);
    }

    @DisplayName("6.유저3이 유저1을 친구목록에서 제거")
    @Test
    public void test6() throws Exception {
        //given
        User[] users = createFriends(1l, 3l);
        User user1 = users[0];
        User user3 = users[1];
        User fakeUser2 = createUser(2l);
        User fakeUser3 = createUser(3l);

        //mocking
        given(userRepository.findByUuid(USER_UUID[2])).willReturn(Optional.of(fakeUser2));
        given(userRepository.findByUuid(USER_UUID[3])).willReturn(Optional.of(fakeUser3));

        //when
        user3.deleteFriend(user1);

        //then
        assertThat(user3.getFriends().contains(user1)).isEqualTo(false);
        assertThat(user1.getFriends().contains(user3)).isEqualTo(false);
    }

    private User createUser(Long id){
        return User.builder()
                .id(id)
                .uuid(USER_UUID[id.intValue()])
                .nickName("nick"+ id.toString())
                .profileImage("profileImage"+id.toString())
                .build();
    }

    private User createFriendRequestedUser(User user, Long targetId){
        User target = createUser(targetId);
        FriendWait friendWait =  FriendWait.create(user, target);
        target.getFriendWaits().add(friendWait);
        return target;
    }

    private User[] createFriends(Long userId, Long targetId){
        User user = createUser(userId);
        User target = createUser(targetId);
        user.addFriend(target);

        return new User[]{user, target};
    }
}

