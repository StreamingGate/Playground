package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.LiveRoom.LiveRoom;
import com.example.mainservice.entity.Video.Video;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@NoArgsConstructor
@Getter
public class SearchedList {
    private List<Video> videos; //일반 영상 리스트(시청기록 포함)
    private List<LiveRoom> liveRooms; //실시간 리스트
    private Category[] categories= Category.values(); //카테고리 리스트

    public SearchedList(List<Video> videos, List<LiveRoom> liveRooms){
        this.videos = videos;
        this.liveRooms = liveRooms;
    }
}
