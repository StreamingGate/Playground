package com.example.mainservice.entity.Live;

import com.example.mainservice.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LiveRepository extends JpaRepository<Live, Long> {

    @Query("SELECT l FROM Live l ORDER BY l.createdAt DESC")
    Page<Live> findAll(Pageable pageable);

    @Query("SELECT l FROM Live l WHERE l.id < :lastId ORDER BY l.createdAt DESC")
    Page<Live> findAll(@Param("lastId") long lastId, Pageable pageable);

    @Query("SELECT l FROM Live l WHERE l.category=:category  ORDER BY l.createdAt DESC")
    List<Live> findAllByCategory(@Param("category") Category category, Pageable pageable);

    @Query("SELECT l FROM Live l WHERE l.category=:category AND l.id <:lastId ORDER BY l.createdAt DESC")
    List<Live> findAllByCategory(@Param("category") Category category, @Param("lastId")long lastId, Pageable pageable);
}
