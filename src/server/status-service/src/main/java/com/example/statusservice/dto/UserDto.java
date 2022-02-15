package com.example.statusservice.dto;

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
    private Boolean status = false; // login or logout
    private String nickname;
    private String profileImage;
    private List<String> friendUuids = new ArrayList<>();

    // 시청중이 아닐 경우 id, type, videoRoomUuid, title은 null 값
    private Integer id;              // videoId or roomId
    private Integer type;           // 0: videoId, 1: roomId
    private String videoRoomUuid;   // videoUuid or roomUuid
    private String title;

    public UserDto(User user){
        this.uuid = user.getUuid();
        this.nickname = user.getNickName();
        this.profileImage = user.getProfileImage();
        this.friendUuids = user.getBeFriend().stream()
                .map(User::getUuid)
                .collect(Collectors.toList());
    }

    /* 로그인 상태 업데이트 */
    public void updateStatus(Boolean status){
        this.status = status;
        if(status == Boolean.FALSE) clearVideoOrRoom();
    }

    /* 시청 정보 업데이트 */
    public void updateVideoOrRoom(String uuid, UserDto reqUserDto){
        this.uuid = uuid; // uuid from reqUserDto might be null
        this.id = reqUserDto.getId();
        this.type = reqUserDto.getType();
        this.videoRoomUuid = reqUserDto.getVideoRoomUuid();
        this.title = reqUserDto.getTitle();
    }

    /* 그만 시청하기 */
    public void clearVideoOrRoom(){
        this.id = null;
        this.type = null;
        this.videoRoomUuid = null;
        this.title = null;
    }
}
