package com.example.mainservice.entity.ViewdHistory;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ViewedRepository extends JpaRepository<ViewedHistory, Long>{

    @Query("SELECT v FROM ViewedHistory v WHERE v.user.uuid = :userUuid AND v.video.id = :videoId")
    Optional<ViewedHistory> findByVideoIdAndUserUuid(@Param("userUuid") String userUuid, @Param("videoId") Long videoId);
}
