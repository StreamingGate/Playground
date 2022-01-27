package com.example.mainservice.entity.FriendWait;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FriendWaitRepository extends JpaRepository<FriendWait, Long>{

//    Optional<FriendWait> findByReceiver()
}
