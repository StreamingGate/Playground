package com.example.userservice.service;

import com.example.userservice.dto.RegisterUser;
import com.example.userservice.dto.UserDto;
import com.example.userservice.entity.User.UserEntity;
import com.example.userservice.entity.User.UserRepository;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.RandomStringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final ModelMapper mapper;
    private final JavaMailSender javaMailSender;
    private final RedisTemplate<String,Object> redisTemplate;

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
        userRepository.save(UserEntity.create(userDto,uuid,bcryptPwd));
        return userDto;
    }

    @Transactional
    public RegisterUser update(String uuid,RegisterUser requestDto) throws CustomUserException{
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserEntity userEntity = userRepository.findByUuid(uuid);
        Date date = new Date();
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        if(checkNickName(requestDto.getNickName())) {
            String bcryptPwd = "";
            if(requestDto.getPassword() != null) bcryptPwd = bCryptPasswordEncoder.encode(requestDto.getPassword());
            userEntity.update(requestDto,localDate,bcryptPwd);
            requestDto = mapper.map(userEntity,RegisterUser.class);
            return requestDto;
        }
        throw new CustomUserException(ErrorCode.U004);
    }

    @Transactional
    public void delete(String uuid) {
        UserEntity userEntity = userRepository.findByUuid(uuid);
        Date date = new Date();
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        userEntity.delete(localDate);
    }

    @Transactional(readOnly = true)
    public String checkEmail(String email) throws CustomUserException{
        if(!userRepository.findByEmail(email).isPresent()) {
            String randomCode = sendEmail(email);
            // 만약 n번의 요청할시, 인증코드를 overwrite
            redisTemplate.opsForValue().set(randomCode,email,60*10L, TimeUnit.SECONDS);
            return email;
        }
        throw new CustomUserException(ErrorCode.U001);
    }

    @Transactional(readOnly = true)
    public String checkUser(String name,String email) throws CustomUserException {
        if(userRepository.findByNameAndEmail(name,email).isPresent()) {
            String randomCode = sendEmail(email);
            redisTemplate.opsForValue().set(randomCode,email,60*10L, TimeUnit.SECONDS);
            return email;
        }
        throw new CustomUserException(ErrorCode.U005);
    }

    @Transactional
    public String checkCode(String code) throws CustomUserException{
        String email = (String) redisTemplate.opsForValue().get(code);
        if (email != null) {
            redisTemplate.delete(code);
            return email;
        }
        throw new CustomUserException(ErrorCode.U003);
    }

    @Transactional(readOnly = true)
    public boolean checkNickName(String nickName) throws CustomUserException {
        return Optional.of(!userRepository.findByNickName(nickName).isPresent()).orElseThrow(()-> new CustomUserException(ErrorCode.U004));
    }

    @Transactional(readOnly = true)
    public UserDto getUserByEmail(String email) {
        UserEntity userEntity = userRepository.findByEmail(email).orElseThrow(()-> new CustomUserException(ErrorCode.U002));
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto userDto = mapper.map(userEntity,UserDto.class);
        return userDto;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws CustomUserException {
        UserEntity userEntity = userRepository.findByEmail(email).orElseThrow(()-> new CustomUserException(ErrorCode.U002));

        if (userEntity == null)
            throw new UsernameNotFoundException(email + ": not found");
        List<GrantedAuthority> authorities = new ArrayList<>();
        User user = new User(userEntity.getEmail(), userEntity.getPwd(),
                true, true, true, true,authorities);
        return user;
    }
}
