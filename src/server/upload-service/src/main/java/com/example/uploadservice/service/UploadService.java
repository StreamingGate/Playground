package com.example.uploadservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.example.uploadservice.dto.VideoDto;
import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import com.example.uploadservice.exceptionHandler.customexception.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Uplaod video file into AWS S3
 */
@Slf4j
@Service
public class UploadService {

    private static final String DEFAULT_VIDEO_NAME = "video";
    private static final String DEFAULT_THUMBNAIL_NAME = "thumbnail";
    private final String LOCAL_FILEPATH;
    private final String BUCKET;
    private final String INPUT_DIR;
    private final String OUTPUT_DIR;
    private final String RESULT_PREFIX;
    private final AmazonS3 amazonS3;

    @Autowired
    public UploadService(@Value("${bin.path}") String localFilePath,
                         @Value("${cloud.aws.s3.image.bucket}") String bucket,
                         @Value("${cloud.aws.s3.image.input-dir}") String inputDir,
                         @Value("${cloud.aws.s3.image.output-dir}") String outputDir,
                         @Value("${cloud.aws.s3.image.result-prefix}") String resultPrefix,
                         AmazonS3 amazonS3) {
        this.LOCAL_FILEPATH = localFilePath;
        this.BUCKET = bucket;
        this.INPUT_DIR = inputDir;
        this.OUTPUT_DIR = outputDir;
        this.RESULT_PREFIX = resultPrefix;
        this.amazonS3 = amazonS3;
    }

    /**
     * upload video to s3 "input" folder
     */
    public String uploadRawFile(MultipartFile multipartFileVideo, MultipartFile multipartFileThumbnail, VideoDto videoDto)
            throws CustomUploadException {
        String videoUuid = UUID.randomUUID().toString();

        // upload video
        if (multipartFileVideo.isEmpty()) throw new CustomUploadException(ErrorCode.I001, "첨부한 비디오 파일이 비어있습니다");
        String fileLink = getKey(multipartFileVideo, videoUuid);
        log.info("fileLink:" + fileLink);
        upload(multipartFileVideo, fileLink);
        videoDto.updateMetaData(videoUuid, multipartFileVideo.getSize(), LocalDateTime.now());

        // upload thumbnail
        if (multipartFileThumbnail != null) {
            String thumbnailLink = getKey(multipartFileThumbnail, videoUuid);
            upload(multipartFileThumbnail, thumbnailLink);
            log.info("thumbnailLink:" + thumbnailLink);
        }
        return videoUuid;
    }

    /**
     * rename key(s3 path)
     */
    private String getKey(MultipartFile multipartFile, String videoUuid) throws CustomUploadException {
        String originalFilename = multipartFile.getOriginalFilename();
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        if (multipartFile.getName().equals(DEFAULT_VIDEO_NAME)) return INPUT_DIR + "/" + videoUuid + "/" + DEFAULT_VIDEO_NAME + "." + ext;
        else return OUTPUT_DIR + "/" + videoUuid + "/" + DEFAULT_THUMBNAIL_NAME + "." + ext;
    }

    public void upload(MultipartFile multipartFile, String key) {
        try {
            InputStream inputStream = multipartFile.getInputStream();
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentLength(multipartFile.getSize());
            amazonS3.putObject(new PutObjectRequest(BUCKET, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead)); // public 권한으로 설정
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String uploadTranscodedFile(String videoUuid) throws CustomUploadException {
        uploadAllLocalFiles(videoUuid);
        log.info("uploaded transcoded files...");
        deleteAllLocalFiles(videoUuid);
        log.info("deleted transcoded files...");
        return RESULT_PREFIX + "/" + videoUuid;
    }

    private void uploadAllLocalFiles(String videoUuid) {
        try {
            File targetFolder = new File(LOCAL_FILEPATH + File.separator + videoUuid);
            if (!targetFolder.exists()) return;
            File[] files = targetFolder.listFiles();
            for (File file : files) {
                final String OUTPUT_FILEPATH = OUTPUT_DIR + "/" + videoUuid + "/" + file.getName();
                amazonS3.putObject(new PutObjectRequest(BUCKET, OUTPUT_FILEPATH, file)
                        .withCannedAcl(CannedAccessControlList.PublicRead));    // public 권한으로 설정
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteAllLocalFiles(String videoUuid) {
        try {
            File file = new File(LOCAL_FILEPATH + File.separator + videoUuid);
            FileUtils.cleanDirectory(file);
            file.delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}