package com.example.mainservice.entity.LiveViewer;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface LiveViewerRepository extends JpaRepository<LiveViewer, Long>{
    @Query("SELECT l FROM LiveViewer l WHERE l.userEntity.uuid = :userUuid AND l.liveRoom.id = :liveRoomId")
    Optional<LiveViewer> findByLiveRoomIdAndUserUuid(@Param("userUuid")String userUuid, @Param("liveRoomId")Long liveRoomId);
}
