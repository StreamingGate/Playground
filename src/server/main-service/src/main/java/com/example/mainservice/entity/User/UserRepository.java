package com.example.mainservice.entity.User;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity,Long> {
    Optional<UserEntity> findByEmail(String email);
    UserEntity findByNickName(String nickName);
    UserEntity findByUuid(String uuid);
}