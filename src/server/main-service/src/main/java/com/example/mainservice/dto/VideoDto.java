package com.example.mainservice.dto;

import com.example.mainservice.entity.Category;
import com.example.mainservice.entity.Video.Video;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.modelmapper.ModelMapper;

import java.time.LocalDateTime;

@Data
public class VideoDto {

    private Long id;
    private String title;
    private String uploaderNickname;
    private int hits;
    private String fileLink;
    private String thumbnail;
    private Category category;
    private LocalDateTime createdAt;

    public static VideoDto fromEntity(ModelMapper mapper, Video video){
        VideoDto videoDto = mapper.map(video, VideoDto.class);
        videoDto.setFileLink(video.getMetadata().getFileLink());
        return videoDto;
    }
}
