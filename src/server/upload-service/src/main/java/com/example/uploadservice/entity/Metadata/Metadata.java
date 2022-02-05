package com.example.uploadservice.entity.Metadata;

import com.example.uploadservice.entity.Video.Video;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import javax.persistence.*;
import java.time.LocalDateTime;


@NoArgsConstructor
@Getter
@Entity
public class Metadata {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT")
    private String fileLink;

    @Column(length = 50)
    private String fileName;

    private Long size;

    private LocalDateTime videoCreatedAt;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private VideoState state;

    private String uploaderEmail;

    @OneToOne(mappedBy = "metadata")
    private Video video;

    @Builder
    public Metadata(String fileLink,String fileName, Long size, LocalDateTime videoCreatedAt, String uploaderEmail){
        this.fileLink = fileLink;
        this.fileName = fileName;
        this.size = size;
        this.videoCreatedAt = videoCreatedAt;
        this.state = VideoState.NORMAL;
        this.uploaderEmail = uploaderEmail;
    }
}
