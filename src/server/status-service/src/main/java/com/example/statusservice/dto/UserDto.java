package com.example.statusservice.dto.login;

import com.example.statusservice.entity.User.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDto implements Serializable {

    private static final long serialVersionUID = 1444478977089006638L;

    private String uuid;            // user uuid
    private Boolean status = false;         // login or logout
    private List<String> friendUuids = new ArrayList<>();

    private String id;              // videoId or roomId
    private Integer type;           // 0: videoId, 1: roomId
    private String videoRoomUuid;   // videoUuid or roomUuid
    private String title;

    public UserDto(User user){
        this.uuid = user.getUuid();
        this.friendUuids = user.getBeFriend().stream()
                .map(User::getUuid)
                .collect(Collectors.toList());
    }

    public void updateStatus(Boolean status){
        this.status = status;
    }

    /* 시청 정보 업데이트 */
    public void updateVideoOrRoom(String id, Integer type, String videoRoomUuid, String title){
        this.id = id;
        this.type = type;
        this.videoRoomUuid = videoRoomUuid;
        this.title = title;
    }
}
