package com.example.userservice.entity.RoomViewer;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RoomViewerRepository extends JpaRepository<RoomViewer,Long> {
    @Query("select r FROM RoomViewer r where r.userUuid = :userUuid ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByAll (@Param("userUuid") String userUuid, Pageable pageable);

    @Query("select r FROM RoomViewer r where r.userUuid = :userUuid AND r.Id < :lastLiveId ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByAll (@Param("userUuid") String userUuid, @Param("lastLiveId") Long lastLiveId, Pageable pageable);

    @Query("select r FROM RoomViewer r where r.userUuid = :userUuid AND r.liked = true ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByLiked (@Param("userUuid") String userUuid, Pageable pageable);

    @Query("select r FROM RoomViewer r where r.userUuid = :userUuid AND r.Id < :lastLiveId AND r.liked = true ORDER BY r.lastViewedAt DESC")
    Page<RoomViewer> findByLiked (@Param("userUuid") String userUuid, @Param("lastLiveId") Long lastLiveId, Pageable pageable);
}
