package com.example.roomservice.entity.RoomViewer;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomViewerRepository extends JpaRepository<RoomViewer,Long> {
    RoomViewer findByUserUuidAndRoomUuid(String userUuid,Long roomUuid);
}
