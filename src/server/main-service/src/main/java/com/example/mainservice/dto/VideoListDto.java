package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * <h1>HomeList</h1>
 * 홈 화면 접속시, 검색시 보여주는 영상 리스트(페이지네이션 필요)
 */
@NoArgsConstructor
@Setter
@Getter
public class VideoListDto {

    private List<VideoDto> videos; //일반 영상 리스트(시청기록 포함)
    private List<LiveRoomDto> liveRooms; //실시간 리스트
    private Category[] categories= Category.values(); //카테고리 리스트

    public VideoListDto(List<VideoDto> videos, List<LiveRoomDto> liveRooms){
        this.videos = videos;
        this.liveRooms = liveRooms;
    }
}
