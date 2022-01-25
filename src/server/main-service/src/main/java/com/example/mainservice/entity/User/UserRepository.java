package com.example.mainservice.entity.User;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity,Long> {
    Optional<UserEntity> findByEmail(String email);
    Optional<UserEntity> findByNickName(String nickName);
    Optional<UserEntity> findByUuid(String uuid);
    Optional<UserEntity> findByNameAndEmail(String name,String email);
}