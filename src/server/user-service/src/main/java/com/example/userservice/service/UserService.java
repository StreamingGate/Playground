package com.example.userservice.service;

import com.example.userservice.dto.RegisterUser;
import com.example.userservice.dto.UserDto;
import com.example.userservice.entity.User.UserEntity;
import com.example.userservice.entity.User.UserRepository;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
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
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.*;

@Service
@Slf4j
public class UserService implements UserDetailsService {
    private UserRepository userRepository;
    private BCryptPasswordEncoder bCryptPasswordEncoder;
    private ModelMapper mapper;
    private JavaMailSender javaMailSender;

    @Autowired
    public UserService(UserRepository userRepository,
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
        try {
            String bcryptPwd = "";
            if(requestDto.getPassword() != null) bcryptPwd = bCryptPasswordEncoder.encode(requestDto.getPassword());
            userEntity.update(requestDto,localDate,bcryptPwd);
            requestDto = mapper.map(userEntity,RegisterUser.class);
            return requestDto;

        } catch (CustomUserException e){
            throw new CustomUserException(ErrorCode.U002);
        }
    }

    @Transactional
    public void delete(String uuid) {
        UserEntity userEntity = userRepository.findByUuid(uuid);
        Date date = new Date();
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        userEntity.delete(localDate);
    }

    /* TODO :  이메일 인증  */
//    public String checkEmail(String email) {
//        userRepository.findByEmail(email).orElse(sendEmail(email));
//
//
//        return email;
//    }

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
