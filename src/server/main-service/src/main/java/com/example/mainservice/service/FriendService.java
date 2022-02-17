package com.example.mainservice.service;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.dto.FriendWaitDto;
import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.FriendWait.FriendWaitRepository;
import com.example.mainservice.entity.Notification.Notification;
import com.example.mainservice.entity.Notification.NotificationRepository;
import com.example.mainservice.entity.User.User;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.exceptionhandler.customexception.CustomMainException;
import com.example.mainservice.exceptionhandler.customexception.ErrorCode;
import com.example.mainservice.utils.HttpRequest;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class FriendService {

    private final UserRepository userRepository;
    private final FriendWaitRepository friendWaitRepository;
    private final NotificationRepository notificationRepository;
    private final ModelMapper mapper;

    @PostConstruct
    public void init() {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
    }

    @Transactional(readOnly = true)
    public List<FriendDto> getFriendList(String uuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        return user.getFriends().stream()
                .map(friend -> FriendDto.from(friend))
                .collect(Collectors.toList());
    }

    @Transactional
    public String requestFriend(String uuid, String targetUuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        User target = userRepository.findByUuid(targetUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        // 이미 친구인지 확인
        if (target.getFriends().contains(user)) throw new CustomMainException(ErrorCode.F003);

        // 이미 신청받았는지 확인
        Optional<FriendWait> alreadyWaiting = target.getFriendWaits().stream()
                .filter(fw -> fw.getSenderUuid().equals(uuid))
                .findFirst();
        if (alreadyWaiting.isPresent()) throw new CustomMainException(ErrorCode.F002);

        /* TODO: 삭제할 가능성 있음 */
        FriendWait friendWait = FriendWait.create(user, target);
        friendWaitRepository.save(friendWait);
        /*=======================*/

        Notification notification = Notification.createFriendRequest(user, target);
        notificationRepository.save(notification); /* TODO push알림으로 수정하기 */
        return target.getUuid();
    }

    @Transactional
    public String deleteFriend(String uuid, String targetUuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        User target = userRepository.findByUuid(targetUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        user.deleteFriend(target);
        HttpRequest.sendDeleteFriend(FriendDto.from(user), FriendDto.from(target));
        return target.getUuid();
    }

    @Transactional(readOnly = true)
    public List<FriendWaitDto> getFriendWaitList(String uuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        return user.getFriendWaits().stream()
                .map(FriendWaitDto::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public String allowFriendRequest(String uuid, String senderUuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        User sender = userRepository.findByUuid(senderUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        // FriendWait에서 row 삭제
        FriendWait friendWait = user.getFriendWaits().stream()
                .filter(fw -> fw.getSenderUuid().equals(senderUuid))
                .findFirst()
                .orElseThrow(() -> new CustomMainException(ErrorCode.F001));
        friendWaitRepository.delete(friendWait);

        // 이미 친구인지 확인
        if (sender.getFriends().contains(user)) throw new CustomMainException(ErrorCode.F003);

        // User friends 에 추가
        sender.addFriend(user);
        HttpRequest.sendAddFriend(FriendDto.from(user), FriendDto.from(sender));
        return sender.getUuid();
    }

    @Transactional
    public String refuseFriendRequest(String uuid, String senderUuid) throws Exception {
        User user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        // FriendWait에서 row 삭제
        FriendWait friendWait = user.getFriendWaits().stream()
                .filter(fw -> fw.getSenderUuid().equals(senderUuid))
                .findFirst()
                .orElseThrow(() -> new CustomMainException(ErrorCode.F001));
        friendWaitRepository.delete(friendWait);

        return senderUuid;
    }
}
