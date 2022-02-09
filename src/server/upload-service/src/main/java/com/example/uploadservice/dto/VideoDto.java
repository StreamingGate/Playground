package com.example.uploadservice.dto;

import com.example.uploadservice.entity.Category;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@NoArgsConstructor
@Data
public class VideoDto {

    private static final String DEFAULT_THUMBNAIL_NAME = "thumbnail";

    private String title;
    private String content;
    private Category category;
    private String videoUuid;
    private String uploaderUuid;
    private String thumbnailName;
    private String s3OutputPath; // folder path
    private Long size;
    private LocalDateTime videoCreatedAt;

    public VideoDto(UploadRequestDto dto){
        this.title = dto.getTitle();
        this.content = dto.getContent();
        this.category = dto.getCategory();
        this.uploaderUuid = dto.getUuid();
    }

    public void updateThumbnailName(String originalName){
        this.thumbnailName = DEFAULT_THUMBNAIL_NAME + "." + originalName.split("\\.")[1];
    }
    /**
     * raw file upload 직후
     */
    public void updateMetaData(String videoUuid, Long size, LocalDateTime videoCreatedAt){
        this.videoUuid= videoUuid;
        this.size = size;
        this.videoCreatedAt = videoCreatedAt;
    }

    /**
     * DB Video 테이블에 업로드 시
     */
    public void updateMetaData(String s3OutputPath){
        this.s3OutputPath = s3OutputPath;
    }
}
