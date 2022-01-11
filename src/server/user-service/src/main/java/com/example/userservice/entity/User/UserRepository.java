package com.example.userservice.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity,Long> {
    UserEntity findByEmail(String email);
    UserEntity findByNickName(String nickName);
}
