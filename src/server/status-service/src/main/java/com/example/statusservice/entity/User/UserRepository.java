package com.example.statusservice.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User,Long> {
    Optional<User> findByEmail(String email);
    Optional<User> findByNickName(String nickName);
    Optional<User> findByUuid(String uuid);
    Optional<User> findByNameAndEmail(String name, String email);
}