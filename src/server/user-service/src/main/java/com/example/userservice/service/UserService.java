package com.example.userservice.service;

import com.example.userservice.configure.security.Jwt;
import com.example.userservice.dto.history.ResponseRoom;
import com.example.userservice.dto.history.ResponseVideo;
import com.example.userservice.dto.user.*;
import com.example.userservice.entity.RoomViewer.RoomViewer;
import com.example.userservice.entity.RoomViewer.RoomViewerRepository;
import com.example.userservice.entity.User.User;
import com.example.userservice.entity.User.UserRepository;
import com.example.userservice.entity.Video.Video;
import com.example.userservice.entity.Video.VideoRepository;
import com.example.userservice.entity.ViewdHistory.ViewedHistory;
import com.example.userservice.entity.ViewdHistory.ViewedRepository;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final VideoRepository videoRepository;
    private final ViewedRepository viewedRepository;
    private final RoomViewerRepository roomViewerRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final ModelMapper mapper;
    private final JavaMailSender javaMailSender;
    private final RedisTemplate<String,Object> redisTemplate;
    private final AmazonS3Service amazonS3Service;
    private final HistoryService historyService;
    private final Jwt jwt;

    public String sendEmail(String address) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(address);
        message.setSubject("이메일 인증코드 입니다.");
        String randomCode = RandomStringUtils.randomAlphanumeric(10);
        message.setText("임시 인증 코드는 "+randomCode+" 입니다.");
        javaMailSender.send(message);
        return randomCode;
    }

    @Transactional
    public RegisterUser register(RegisterUser userDto) throws CustomUserException {
        String uuid =  UUID.randomUUID().toString();
        String bcryptPwd = bCryptPasswordEncoder.encode(userDto.getPassword());
        userDto.setProfileImage(amazonS3Service.upload(userDto.getProfileImage(),uuid));
        userRepository.save(User.create(userDto,uuid,bcryptPwd));
        return userDto;
    }

    @Transactional
    public ResponseUser update(String uuid, RequestMyinfo requestDto) throws CustomUserException {
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        User user = userRepository.findByUuid(uuid).orElseThrow(()-> new CustomUserException(ErrorCode.U002));
        ResponseUser responseDto = mapper.map(user,ResponseUser.class);
        try {
            if (requestDto.getProfileImage() != null) {
                amazonS3Service.delete(uuid);
                responseDto.setProfileImage(amazonS3Service.upload(requestDto.getProfileImage(),uuid));
                requestDto.setProfileImage(responseDto.getProfileImage());
            }
            if (checkNickName(requestDto.getNickName()) != null) user.update(requestDto);
            responseDto.setNickName(requestDto.getNickName());
        } catch (CustomUserException e){
            throw new CustomUserException(ErrorCode.U004);
        }
        return responseDto;
    }

    @Transactional
    public void delete(String uuid) throws CustomUserException {
        User user = userRepository.findByUuid(uuid).orElseThrow(()-> new CustomUserException(ErrorCode.U002));
        LocalDateTime localDateTime = LocalDateTime.now();
        user.delete(localDateTime);
    }

    @Transactional
    public EmailDto checkEmail(EmailDto email) throws CustomUserException {
        if(!userRepository.findByEmail(email.getEmail()).isPresent()) {
            String randomCode = sendEmail(email.getEmail());
            // 만약 n번의 요청할시, 인증코드를 overwrite
            redisTemplate.opsForValue().set(randomCode,email.getEmail(),60*10L, TimeUnit.SECONDS);
            return email;
        }
        throw new CustomUserException(ErrorCode.U001);
    }

    @Transactional
    public PwdDto checkUser(PwdDto pwdDto) throws CustomUserException {
        if(userRepository.findByNameAndEmail(pwdDto.getName(),pwdDto.getEmail()).isPresent()) {
            String randomCode = sendEmail(pwdDto.getEmail());
            redisTemplate.opsForValue().set(randomCode,pwdDto.getEmail(),60*10L, TimeUnit.SECONDS);
            return pwdDto;
        }
        throw new CustomUserException(ErrorCode.U005);
    }

    @Transactional
    public String checkCode(String code) throws CustomUserException {
        String email = (String) redisTemplate.opsForValue().get(code);
        if (email != null) {
            redisTemplate.delete(code);
            return email;
        }
        throw new CustomUserException(ErrorCode.U003);
    }

    @Transactional
    public String checkNickName(String nickName) throws CustomUserException {
        if(!userRepository.findByNickName(nickName).isPresent()) return nickName;
        throw new CustomUserException(ErrorCode.U004);
    }

    @Transactional
    public PwdDto updatePwd(String uuid, PwdDto pwdDto) throws CustomUserException {
        User user = userRepository.findByUuid(uuid).orElseThrow(()-> new CustomUserException(ErrorCode.U002));
        String bcryptPwd = bCryptPasswordEncoder.encode(pwdDto.getPassword());
        user.updatePwd(bcryptPwd);
        return pwdDto;
    }

    @Transactional
    public UserDto getUserByEmail(String email) throws CustomUserException {
        User user = userRepository.findByEmail(email).orElseThrow(()-> new CustomUserException(ErrorCode.U002));
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto userDto = mapper.map(user,UserDto.class);
        return userDto;
    }

    @Transactional
    public List<?> watchedHistory(String uuid, Long lastVideoId, Long lastLiveId,int size) throws CustomUserException {
        if (!userRepository.findByUuid(uuid).isPresent()) throw new CustomUserException(ErrorCode.U002);
        Stream<ViewedHistory> videoStream;
        Stream<RoomViewer> liveStream;
        Pageable pageable = PageRequest.of(0, size);

        if(lastVideoId == -1) videoStream = viewedRepository.findByAll(uuid,pageable).getContent().stream();
        else videoStream = viewedRepository.findByAll(uuid,lastVideoId, pageable).getContent().stream();

        if(lastLiveId == -1) liveStream = roomViewerRepository.findByAll(uuid, pageable).stream();
        else liveStream = roomViewerRepository.findByAll(uuid, lastLiveId, pageable).stream();

        List<ResponseVideo> videoList = videoStream.map(ResponseVideo::new)
                .collect(Collectors.toList());
        List<ResponseRoom> roomList = liveStream.map(ResponseRoom::new)
                .collect(Collectors.toList());

        /* 두 리스트 정렬해서 합치기(Two Pointer) */
        return historyService.watchedHistory(videoList,roomList);
    }
    @Transactional
    public List<?> likedHistory(String uuid, Long lastVideoId, Long lastLiveId,int size) throws CustomUserException {
        if (!userRepository.findByUuid(uuid).isPresent()) throw new CustomUserException(ErrorCode.U002);
        Stream<ViewedHistory> videoStream;
        Stream<RoomViewer> liveStream;
        Pageable pageable = PageRequest.of(0, size);

        if (lastVideoId == -1) videoStream = viewedRepository.findByLiked(uuid,pageable).getContent().stream();
        else videoStream = viewedRepository.findByLiked(uuid,lastVideoId,pageable).getContent().stream();

        if(lastLiveId == -1) liveStream = roomViewerRepository.findByLiked(uuid,pageable).getContent().stream();
        else liveStream = roomViewerRepository.findByLiked(uuid,lastLiveId,pageable).getContent().stream();

        List<ResponseVideo> videoList = videoStream.map(ResponseVideo::new)
                .collect(Collectors.toList());
        List<ResponseRoom> roomList = liveStream.map(ResponseRoom::new)
                .collect(Collectors.toList());
        /* 두 리스트 정렬해서 합치기(Two Pointer) */
        return historyService.likedHistory(videoList,roomList);
    }

    @Transactional
    public List<ResponseVideo> uploadedHistory(String uuid, Long lastVideoId, int size) throws CustomUserException {
        if (!userRepository.findByUuid(uuid).isPresent()) throw new CustomUserException(ErrorCode.U002);
        Stream<Video> videoStream;
        Pageable pageable = PageRequest.of(0, size);
        if (lastVideoId == -1) videoStream = videoRepository.findAll(uuid,pageable).getContent().stream();
        else videoStream = videoRepository.findAll(uuid,lastVideoId,pageable).getContent().stream();
        return videoStream.map(ResponseVideo::new).collect(Collectors.toList());
    }

    public String refreshToken(String token, String refreshToken) throws CustomUserException {
        if(!redisTemplate.hasKey(refreshToken)) throw new CustomUserException(ErrorCode.U007);
        String userUuid = jwt.getUserUuid(token);
        if(!userRepository.findByUuid(userUuid).isPresent()) throw new CustomUserException(ErrorCode.U007);
        String newAccessToken = jwt.createToken(userUuid);
        return newAccessToken;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws CustomUserException {
        User userEntity = userRepository.findByEmail(email).orElseThrow(()-> new CustomUserException(ErrorCode.U002));

        if (userEntity == null)
            throw new UsernameNotFoundException(email + ": not found");
        List<GrantedAuthority> authorities = new ArrayList<>();
        org.springframework.security.core.userdetails.User user = new org.springframework.security.core.userdetails.User(userEntity.getEmail(), userEntity.getPwd(),
                true, true, true, true,authorities);
        return user;
    }
}
