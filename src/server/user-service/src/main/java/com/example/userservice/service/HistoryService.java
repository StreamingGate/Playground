package com.example.userservice.service;

import com.example.userservice.dto.history.ResponseRoom;
import com.example.userservice.dto.history.ResponseVideo;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class HistoryService {
    public List<?> watchedHistory(List<ResponseVideo> videoList, List<ResponseRoom> roomList) {
        List<? super Object> res = new ArrayList<>();
        int i = 0, j = 0;
        int videoListLen = videoList.size(), roomListLen = roomList.size();
        while (i+j < videoListLen+roomListLen) {
            if (i < videoListLen) {
                if (j == roomListLen) {
                    new ArrayList<>(videoList.subList(i,videoListLen)).stream().forEach(obj -> res.add(obj));
                    break;
                }
                else if (videoList.get(i).getLastViewedAt().isAfter(roomList.get(j).getLastViewedAt())) res.add(videoList.get(i++));
            }
            if (j < roomListLen) {
                if (i == videoListLen) {
                    new ArrayList<>(roomList.subList(i,roomListLen)).stream().forEach(obj -> res.add(obj));
                    break;
                }
                else if (roomList.get(j).getLastViewedAt().isAfter(videoList.get(i).getLastViewedAt())) res.add(roomList.get(j++));
            }
        }
        return res;
    }

    public List<?> likedHistory(List<ResponseVideo> videoList,List<ResponseRoom> roomList) {
        List<? super Object> res = new ArrayList<>();
        int i = 0, j = 0;
        int videoListLen = videoList.size(), roomListLen = roomList.size();
        while (i+j < videoListLen+roomListLen) {
            if (i < videoListLen) {
                if (j == roomListLen) {
                    new ArrayList<>(videoList.subList(i,videoListLen)).stream().forEach(obj -> res.add(obj));
                    break;
                }
                else if (videoList.get(i).getLikedAt().isAfter(roomList.get(j).getLikedAt())) res.add(videoList.get(i++));
            }
            if (j < roomListLen) {
                if (i == videoListLen) {
                    new ArrayList<>(roomList.subList(i,roomListLen)).stream().forEach(obj -> res.add(obj));
                    break;
                }
                else if (roomList.get(j).getLikedAt().isAfter(videoList.get(i).getLikedAt())) res.add(roomList.get(j++));
            }
        }
        return res;
    }

}
