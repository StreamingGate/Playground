package com.example.userservice.entity.Video;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface VideoRepository extends JpaRepository<Video, Long> {

    @Query("SELECT v FROM Video v WHERE v.uuid = :uuid ORDER BY v.createdAt DESC")
    Page<Video> findAll(String uuid,Pageable pageable);

    @Query("SELECT v FROM Video v WHERE v.uuid = :uuid AND v.id < :lastId ORDER BY v.createdAt DESC")
    Page<Video> findAll(String uuid, @Param("lastId") long lastId, Pageable pageable);
}
