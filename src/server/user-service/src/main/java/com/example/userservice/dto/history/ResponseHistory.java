package com.example.userservice.dto.history;

import com.example.userservice.entity.User.Category;
import lombok.Data;
import java.util.List;

@Data
public class ResponseHistory {
    private List<ResponseVideo> videos; //일반 영상 리스트(시청기록 포함)
    private List<ResponseRoom> rooms; //실시간 리스트
    private Category[] categories = Category.values(); //카테고리 리스트

    public ResponseHistory(List<ResponseVideo> videos, List<ResponseRoom> rooms) {
        this.videos = videos;
        this.rooms = rooms;
    }
    public ResponseHistory(List<ResponseVideo> videos) {
        this.videos = videos;
    }
}
