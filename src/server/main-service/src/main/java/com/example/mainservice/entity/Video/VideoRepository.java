package com.example.mainservice.entity.Video;

import com.example.mainservice.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VideoRepository extends JpaRepository<Video, Long>{
    @Query("SELECT v FROM Video v ORDER BY v.createdAt DESC")
    Page<Video> findAll(Pageable pageable);

    @Query("SELECT v FROM Video v WHERE v.category =:category ORDER BY v.createdAt DESC")
    List<Video> findAllByCategory(@Param("category") Category category, Pageable pageable);

}
