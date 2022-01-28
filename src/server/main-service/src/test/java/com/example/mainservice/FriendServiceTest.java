//package com.example.mainservice;
//
//import com.example.mainservice.entity.FriendWait.FriendWait;
//import com.example.mainservice.entity.FriendWait.FriendWaitRepository;
//import com.example.mainservice.entity.User.UserEntity;
//import com.example.mainservice.entity.User.UserRepository;
//import com.example.mainservice.exceptionHandler.customexception.CustomMainException;
//import com.example.mainservice.exceptionHandler.customexception.ErrorCode;
//import lombok.extern.slf4j.Slf4j;
//import org.junit.jupiter.api.BeforeAll;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.TestInstance;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
//import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
//import org.springframework.test.context.junit.jupiter.SpringExtension;
//
//import java.util.List;
//
//import static org.assertj.core.api.Assertions.assertThat;
//
//@Slf4j
//@TestInstance(TestInstance.Lifecycle.PER_CLASS)
//@ExtendWith(SpringExtension.class)
//@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
//@DataJpaTest
//public class FriendServiceTest {
//
//    @Autowired
//    private UserRepository userRepository;
//
//    @Autowired
//    private FriendWaitRepository friendWaitRepository;
//
//    /**
//     * user1-2, 1-3 친구 관계 생성
//     */
//    @BeforeAll
//    public void setUp() {
//        UserEntity user1 = userRepository.findById(1l).orElse(null);
//        UserEntity user2 = userRepository.findById(2l).orElse(null);
//        UserEntity user3 = userRepository.findById(3l).orElse(null);
//        assertThat(user1).isNotNull();
//        assertThat(user2).isNotNull();
//        assertThat(user3).isNotNull();
//        user1.addFriend(user2);
//        user1.addFriend(user3);
//    }
//
//    @DisplayName("내가 추가한 친구를 친구목록에서 조회")
//    @Test
//    public void test1() {
//        //given
//        UserEntity user1 = userRepository.findById(1l).orElse(null);
//        //when
//        List<UserEntity> friends = user1.getFriends();
//        //then
//        assertThat(user1.getFriends().size()).isEqualTo(2);
//        for(UserEntity u : friends){
//            log.info(u.getNickName());
//        }
//    }
//
//    @DisplayName("내가 추가한 내 친구의 친구 목록에서 나를 조회")
//    @Test
//    public void test2() {
//        //given
//        UserEntity user1 = userRepository.findById(1l).orElse(null);
//        UserEntity user2 = userRepository.findById(2l).orElse(null);
//        //when
//        List<UserEntity> friends = user2.getFriends();
//        //then
//        assertThat(user2.getFriends().size()).isEqualTo(1);
//        assertThat(friends.get(0)).isEqualTo(user1);
//        log.info(friends.get(0).getNickName());
//
//    }
//
//    @DisplayName("유저2가 유저3에게 친구 정상 요청하면 친구대기목록에 추가됨")
//    @Test
//    public void test3() {
//        //given
//        UserEntity user2 = userRepository.findById(2l).orElse(null);
//        UserEntity user3 = userRepository.findById(3l).orElse(null);
//        //when
//        FriendWait friendWait = FriendWait.builder()
//                .senderUuid(user2.getUuid())
//                .senderNickname(user2.getNickName())
//                .senderProfileImage(user2.getProfileImage())
//                .userEntity(user3)
//                .build();
//        friendWaitRepository.save(friendWait);
//        //then
//        assertThat(user3.getFriendWaits().size()).isEqualTo(1);
//    }
//
//    @DisplayName("유저3이 유저2에게서 온 친구요청 수락하면 친구목록에 추가, 대기목록에서 삭제됨")
//    @Test
//    public void test4() {
//        //given
//        final String uuid = "22222222-1234-1234-123456789012";
//        UserEntity user = userRepository.findById(2l).orElse(null);
//        UserEntity target = userRepository.findById(3l).orElse(null);
//
//        //when
//        FriendWait friendWait = target.getFriendWaits().stream()        // FriendWait에서 row 삭제
//                .filter(fw -> fw.getSenderUuid().equals(uuid))
//                .findFirst()
//                .orElseThrow(() -> new CustomMainException(ErrorCode.F001));
//        friendWaitRepository.delete(friendWait);
//        target.addFriend(user);         // User friends 에 추가
//
//        //then
//        UserEntity refreshedTarget = userRepository.findById(3l).orElse(null);
//        assertThat(refreshedTarget.getFriendWaits().size()).isEqualTo(0);
//        assertThat(refreshedTarget.getFriends().size()).isEqualTo(1);
//        assertThat(refreshedTarget.getFriends().get(0).getId()).isEqualTo(3);
//    }
//}
//
