package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import lombok.Data;

import java.util.List;

@Data
public class HomeListDto {

    private List<VideoResponseDto> videos;  //일반 영상 리스트(시청기록 포함)
    private List<RoomResponseDto> rooms;    //실시간 리스트
    private Category[] categories = Category.values(); //카테고리 리스트

    public HomeListDto(List<VideoResponseDto> videos, List<RoomResponseDto> rooms) {
        this.videos = videos;
        this.rooms = rooms;
    }
}
