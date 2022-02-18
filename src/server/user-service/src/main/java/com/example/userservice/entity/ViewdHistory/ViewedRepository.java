package com.example.userservice.entity.ViewdHistory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;

public interface ViewedRepository extends JpaRepository<ViewedHistory, Long>{
//    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid ORDER BY v.lastViewedAt DESC")
//    Page<ViewedHistory> findByUuidAll(@Param("userUuid") String userUuid,Pageable pageable);

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.lastViewedAt < :lastVideoViewedAt ORDER BY v.lastViewedAt DESC")
    Page<ViewedHistory> findByUuidAll(@Param("userUuid") String userUuid, @Param("lastVideoViewedAt") LocalDateTime lastVideoViewedAt, Pageable pageable);

//    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.liked = true ORDER BY v.lastViewedAt DESC")
//    Page<ViewedHistory> findByLiked(@Param("userUuid") String userUuid,Pageable pageable);

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.lastViewedAt < :lastVideoViewedAt AND v.liked = true ORDER BY v.lastViewedAt DESC")
    Page<ViewedHistory> findByLiked(@Param("userUuid") String userUuid, @Param("lastVideoViewedAt") LocalDateTime lastVideoViewedAt, Pageable pageable);

}
