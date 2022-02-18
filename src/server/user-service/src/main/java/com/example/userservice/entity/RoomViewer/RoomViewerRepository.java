package com.example.userservice.entity.RoomViewer;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;

public interface RoomViewerRepository extends JpaRepository<RoomViewer,Long> {
//    @Query("SELECT r FROM RoomViewer r WHERE r.userUuid = :userUuid ORDER BY r.lastViewedAt DESC, r.Id DESC")
//    Page<RoomViewer> findByUuidAll (@Param("userUuid") String userUuid, Pageable pageable);

    @Query("SELECT r FROM RoomViewer r WHERE r.userUuid = :userUuid AND r.lastViewedAt < :lastLiveViewedAt ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByUuidAll (@Param("userUuid") String userUuid, @Param("lastLiveViewedAt") LocalDateTime lastLiveViewedAt, Pageable pageable);

//    @Query("SELECT r FROM RoomViewer r WHERE r.userUuid = :userUuid AND r.liked = true ORDER BY r.lastViewedAt DESC, r.Id DESC")
//    Page<RoomViewer> findByLiked (@Param("userUuid") String userUuid, Pageable pageable);

    @Query("SELECT r FROM RoomViewer r WHERE r.userUuid = :userUuid AND r.lastViewedAt < :lastLiveViewedAt AND r.liked = true ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByLiked (@Param("userUuid") String userUuid, @Param("lastLiveViewedAt") LocalDateTime lastLiveViewedAt, Pageable pageable);
}
