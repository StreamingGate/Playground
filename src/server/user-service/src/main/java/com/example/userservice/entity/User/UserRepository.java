package com.example.userservice.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity,Long> {
    Optional<UserEntity> findByEmail(String email);
    Optional<UserEntity> findByNickName(String nickName);
    UserEntity findByUuid(String uuid);
    Optional<UserEntity> findByNameAndEmail(String name,String email);
}
