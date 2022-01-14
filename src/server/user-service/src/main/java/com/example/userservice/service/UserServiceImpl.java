package com.example.userservice.service;

import com.example.userservice.dto.UserDto;
import com.example.userservice.entity.User.UserEntity;
import com.example.userservice.entity.User.UserRepository;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.RandomStringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {
    UserRepository userRepository;
    BCryptPasswordEncoder bCryptPasswordEncoder;
    ModelMapper mapper;
    JavaMailSender javaMailSender;

    @Autowired
    public UserServiceImpl(UserRepository userRepository,
                           BCryptPasswordEncoder bCryptPasswordEncoder,
                           ModelMapper mapper,
                           JavaMailSender javaMailSender) {
        this.userRepository = userRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
        this.mapper = mapper;
        this.javaMailSender = javaMailSender;
    }

    public String sendEmail(String address) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(address);
        message.setFrom("sgssgmanager@gmail.com");
        message.setSubject("이메일 인증코드 입니다.");
        String randomCode = RandomStringUtils.randomAlphanumeric(10);
        message.setText(randomCode);
        javaMailSender.send(message);
        return randomCode;
    }

    @Override
    @Transactional
    public UserDto createUser(UserDto userDto) throws CustomUserException {
        userDto.setUserId(UUID.randomUUID().toString());
        userDto.setEncryptedPwd(bCryptPasswordEncoder.encode(userDto.getPassword()));
        userRepository.save(UserEntity.createUser(userDto));
        return userDto;
    }

    @Override
    @Transactional
    public UserDto updateUser(String userId,UserDto requestDto) throws CustomUserException{
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserEntity userEntity = userRepository.findByUserId(userId);
        Date date = new Date();
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        try {
            if(requestDto.getPassword() == null) requestDto.setEncryptedPwd(bCryptPasswordEncoder.encode(requestDto.getPassword()));
            userEntity.updateUser(requestDto,localDate);
            requestDto = mapper.map(userEntity,UserDto.class);
            return requestDto;

        } catch (CustomUserException e){
            throw new CustomUserException(ErrorCode.U002,"이미 사용중인 닉네임 입니다.");
        }
    }

    @Override
    @Transactional
    public void deleteUser(String userId) {
        UserEntity userEntity = userRepository.findByUserId(userId);
        Date date = new Date();
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        userEntity.deleteUser(localDate);
    }

    /* TODO :  이메일 인증  */
//    @Override
//    public String checkEmail(String email) {
//        userRepository.findByEmail(email).orElse(sendEmail(email));
//
//
//        return email;
//    }

    @Override
    public UserDto getUserByEmail(String email) {
        UserEntity userEntity = userRepository.findByEmail(email).orElseThrow(()-> new UsernameNotFoundException("찾을수 없는 이메일 입니다."));
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto userDto = mapper.map(userEntity,UserDto.class);
        return userDto;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        UserEntity userEntity = userRepository.findByEmail(email).orElseThrow(()-> new UsernameNotFoundException("찾을수 없는 이메일 입니다."));

        if (userEntity == null)
            throw new UsernameNotFoundException(email + ": not found");
        List<GrantedAuthority> authorities = new ArrayList<>();
        User user = new User(userEntity.getEmail(), userEntity.getPwd(),
                true, true, true, true,authorities);
        return user;
    }



}
