package com.example.userservice.entity.Room;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDate;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long> {
    Optional<Room> findById(Long roomId);

    @Query("SELECT r.createdAt FROM room r WHERE r.title=:title")
    LocalDate getCreatedAt(String title);

    @Query("SELECT r.id from room r WHERE r.uuid = :uuid")
    Long getRoomId(String uuid);

    @Query("SELECT r.id from room r WHERE r.id = :roomId")
    Room getRoom(Long roomId);
}
