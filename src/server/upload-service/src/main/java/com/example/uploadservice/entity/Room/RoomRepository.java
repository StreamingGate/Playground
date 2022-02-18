package com.example.uploadservice.entity.Room;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface RoomRepository extends JpaRepository<Room, Long> {

    @Query("SELECT r FROM Room r ORDER BY r.createdAt DESC")
    Page<Room> findAll(Pageable pageable);
}
