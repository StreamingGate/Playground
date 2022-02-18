package com.example.userservice.entity.Video;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface VideoRepository extends JpaRepository<Video, Long> {

    @Query("SELECT v FROM Video v WHERE v.user.uuid = :uuid ORDER BY v.createdAt DESC")
    Page<Video> findAll(@Param("uuid") String uuid,Pageable pageable);

    @Query("SELECT v FROM Video v WHERE v.user.uuid = :uuid ORDER BY v.createdAt DESC")
    List<Video> findAll(@Param("uuid") String uuid);

    @Query("SELECT v FROM Video v WHERE v.user.uuid = :uuid AND v.id < :lastId ORDER BY v.createdAt DESC")
    Page<Video> findAll(@Param("uuid") String uuid, @Param("lastId") long lastId, Pageable pageable);

}
