package com.example.statusservice.dto;

import com.example.statusservice.entity.User.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
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
    private Set<String> friendUuids = new HashSet<>();

    // 시청중이 아닐 경우 id, type, videoRoomUuid, title은 null 값
    private Integer id;             // videoId or roomId
    private Integer type;           // 0: videoId, 1: roomId
    private String videoRoomUuid;   // videoUuid or roomUuid
    private String title;

    // 친구 추가/삭제시
    private Boolean addOrDelete;    // true: add, false: delete (null: 친구 추가/삭제 이벤트가 아닐 때)
    private String updateTargetUuid;// uuid를 친구 추가/삭제하는 대상의 uuid (null: 친구 추가/삭제 이벤트가 아닐 때)

    public UserDto(User user){
        this.uuid = user.getUuid();
        this.nickname = user.getNickName();
        this.profileImage = user.getProfileImage();
        this.friendUuids = user.getBeFriend().stream()
                .map(User::getUuid)
                .collect(Collectors.toSet());
    }

    public UserDto(FriendDto dto){
        this.uuid = dto.getUuid();
        this.profileImage = dto.getProfileImage();
        this.nickname = dto.getNickname();
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

    /* 친구 추가/삭제 */
    public void updateAddOrDelete(Boolean addOrDelete, String updateTargetUuid){
        this.addOrDelete = addOrDelete;
        this.updateTargetUuid = updateTargetUuid;
    }
}
