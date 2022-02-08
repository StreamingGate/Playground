package com.example.userservice.entity.ViewdHistory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ViewedRepository extends JpaRepository<ViewedHistory, Long>{
    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid ORDER BY v.lastViewedAt desc")
    Page<ViewedHistory> findByAll(@Param("userUuid") String userUuid,Pageable pageable);

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.video.id = :videoId ORDER BY v.lastViewedAt desc")
    Page<ViewedHistory> findByAll(@Param("userUuid") String userUuid, @Param("videoId") Long videoId, Pageable pageable);

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.liked = true ORDER BY v.lastViewedAt desc")
    Page<ViewedHistory> findByLiked(@Param("userUuid") String userUuid,Pageable pageable);

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.video.id = :videoId AND v.liked = true ORDER BY v.lastViewedAt desc")
    Page<ViewedHistory> findByLiked(@Param("userUuid") String userUuid, @Param("videoId") Long videoId, Pageable pageable);

}
