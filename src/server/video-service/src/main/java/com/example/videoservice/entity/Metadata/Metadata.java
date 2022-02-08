package com.example.videoservice.entity.Metadata;

import com.example.videoservice.entity.Video.Video;
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
}
