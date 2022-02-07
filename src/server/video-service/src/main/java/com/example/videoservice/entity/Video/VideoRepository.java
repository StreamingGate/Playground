package com.example.videoservice.entity.Video;


import com.example.videoservice.entity.ViewdHistory.ViewedHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface VideoRepository extends JpaRepository<Video, Long> {

//    @Query("SELECT v FROM Video v ORDER BY v.createdAt DESC")
//    Page<Video> findAll(Pageable pageable);
//
//    @Query("SELECT v FROM Video v WHERE v.id < :lastId ORDER BY v.createdAt DESC")
//    Page<Video> findAll(@Param("lastId") long lastId, Pageable pageable);
//
//    @Query("SELECT v FROM Video v WHERE v.category =:category ORDER BY v.createdAt DESC")
//    List<Video> findAllByCategory(@Param("category") Category category, Pageable pageable);
//
//    @Query("SELECT v FROM Video v WHERE v.category =:category AND v.id < :lastId ORDER BY v.createdAt DESC")
//    List<Video> findAllByCategory(@Param("category") Category category, @Param("lastId") long lastId, Pageable pageable);
//

}
