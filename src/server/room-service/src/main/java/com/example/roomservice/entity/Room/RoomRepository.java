package com.example.roomservice.entity.Room;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long> {
    Optional<Room> findById(Long roomId);

    @Query("SELECT r.createdAt FROM room r WHERE r.title=:title")
    LocalDateTime getCreatedAt(String title);

    @Query("SELECT r.id FROM room r WHERE r.uuid = :uuid")
    Long getRoomId(String uuid);

    @Query("SELECT r.id FROM room r WHERE r.id = :roomId")
    Room getRoom(Long roomId);

    Room findByUuid(String uuid);

    Room findByIdAndHostUuid(Long roomId,String hostUuid);
}
