package com.example.userservice.service;

import com.example.userservice.dto.UserDto;
import com.example.userservice.entity.User.UserEntity;
import com.example.userservice.entity.User.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {
    UserRepository userRepository;
    BCryptPasswordEncoder bCryptPasswordEncoder;
    ModelMapper mapper;

    @Autowired
    public UserServiceImpl(UserRepository userRepository,
                           BCryptPasswordEncoder bCryptPasswordEncoder,
                           ModelMapper mapper) {
        this.userRepository = userRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
        this.mapper = mapper;
    }

    @Override
    public UserDto createUser(UserDto userDto) {
        if(userRepository.findByEmail(userDto.getEmail()) == null) {
            userDto.setEncryptedPwd(bCryptPasswordEncoder.encode(userDto.getPassword()));
            userRepository.save(UserEntity.createUser(userDto));
            return userDto;
        }
        return null;
    }

    @Override
    public UserDto getUserByEmail(String email) {
        UserEntity userEntity = userRepository.findByEmail(email);
        if(userEntity == null)
            throw new UsernameNotFoundException(email);
        mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        UserDto userDto = mapper.map(userEntity,UserDto.class);
        return userDto;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        UserEntity userEntity = userRepository.findByEmail(email);

        if (userEntity == null)
            throw new UsernameNotFoundException(email + ": not found");
        List<GrantedAuthority> authorities = new ArrayList<>();
        User user = new User(userEntity.getEmail(), userEntity.getEncryptedPwd(),
                true, true, true, true,authorities);

        return user;
    }
}
