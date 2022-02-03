package com.example.mainservice.entity.RoomViewer;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface RoomViewerRepository extends JpaRepository<RoomViewer, Long>{
    @Query("SELECT r FROM RoomViewer r WHERE r.user.uuid = :userUuid AND r.room.id = :roomId")
    Optional<RoomViewer> findByLiveRoomIdAndUserUuid(@Param("userUuid")String userUuid, @Param("roomId")Long roomId);
}
