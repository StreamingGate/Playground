package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import lombok.Data;

import java.util.List;

/**
 * <h1>HomeList</h1>
 * 홈 화면 접속시, 검색시 보여주는 영상 리스트(페이지네이션 필요)
 */
@Data
public class HomeListDto {

    private List<VideoResponseDto> videos; //일반 영상 리스트(시청기록 포함)
    private List<RoomResponseDto> rooms; //실시간 리스트
    private Category[] categories = Category.values(); //카테고리 리스트

    public HomeListDto(List<VideoResponseDto> videos, List<RoomResponseDto> rooms) {
        this.videos = videos;
        this.rooms = rooms;
    }
}
