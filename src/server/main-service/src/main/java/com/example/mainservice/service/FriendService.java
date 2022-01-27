package com.example.mainservice.service;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.dto.FriendWaitDto;
import com.example.mainservice.entity.FriendWait.FriendWait;
import com.example.mainservice.entity.FriendWait.FriendWaitRepository;
import com.example.mainservice.entity.User.UserEntity;
import com.example.mainservice.entity.User.UserRepository;
import com.example.mainservice.exceptionHandler.customexception.CustomMainException;
import com.example.mainservice.exceptionHandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class FriendService {

    private final UserRepository userRepository;
    private final FriendWaitRepository friendWaitRepository;
    private final ModelMapper mapper;

    @PostConstruct
    public void init() {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
    }

    @Transactional(readOnly = true)
    public List<FriendDto> getFriendList(String uuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        return user.getFriends().stream()
                .map(friend -> FriendDto.from(friend))
                .collect(Collectors.toList());
    }

    @Transactional
    public String requestFriend(String uuid, String targetUuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        UserEntity target = userRepository.findByUuid(targetUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        FriendWait friendWait = FriendWait.builder()
                .senderUuid(user.getUuid())
                .senderNickname(user.getNickName())
                .senderProfileImage(user.getProfileImage())
                .userEntity(target)
                .build();
        friendWaitRepository.save(friendWait);
        return target.getUuid();
    }

    @Transactional
    public String deleteFriend(String uuid, String targetUuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        UserEntity target = userRepository.findByUuid(targetUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        user.deleteFriend(target);
        return target.getUuid();
    }

    @Transactional(readOnly = true)
    public List<FriendWaitDto> getFriendWaitList(String uuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        return user.getFriendWaits().stream()
                .map(FriendWaitDto::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public String allowFriendRequest(String uuid, String targetUuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));
        UserEntity target = userRepository.findByUuid(targetUuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        // FriendWait에서 row 삭제
        FriendWait friendWait = target.getFriendWaits().stream()
                .filter(fw -> fw.getSenderUuid().equals(uuid))
                .findFirst()
                .orElseThrow(() -> new CustomMainException(ErrorCode.F001));
        friendWaitRepository.delete(friendWait);
        
        // User friends 에 추가
        target.addFriend(user);

        return target.getUuid();
    }

    @Transactional
    public String refuseFriendRequest(String uuid, String targetUuid) throws Exception{
        UserEntity user = userRepository.findByUuid(uuid).orElseThrow(() -> new CustomMainException(ErrorCode.U002));

        // FriendWait에서 row 삭제
        FriendWait friendWait = user.getFriendWaits().stream()
                .filter(fw -> fw.getSenderUuid().equals(targetUuid))
                .findFirst()
                .orElseThrow(() -> new CustomMainException(ErrorCode.F001));
        friendWaitRepository.delete(friendWait);

        return targetUuid;
    }
}
