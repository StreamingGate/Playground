package com.example.mainservice.entity.Room;

import com.example.mainservice.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {

    @Query("SELECT r FROM Room r ORDER BY r.createdAt DESC, r.id DESC")
    Page<Room> findAll(Pageable pageable);

    @Query("SELECT r FROM Room r WHERE r.id < :lastId ORDER BY r.createdAt DESC, r.id DESC")
    Page<Room> findAll(@Param("lastId") long lastId, Pageable pageable);

    @Query("SELECT r FROM Room r WHERE r.category=:category  ORDER BY r.createdAt DESC, r.id DESC")
    List<Room> findAllByCategory(@Param("category") Category category, Pageable pageable);

    @Query("SELECT r FROM Room r WHERE r.category=:category AND r.id <:lastId ORDER BY r.createdAt DESC, r.id DESC")
    List<Room> findAllByCategory(@Param("category") Category category, @Param("lastId")long lastId, Pageable pageable);
}
