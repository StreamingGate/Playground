package com.example.uploadservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.example.uploadservice.dto.UploadResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

/**
 * Uplaod video file into AWS S3
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UploadService {

    private static final String[] ALLOWED_EXT = new String[]{"mp4"};
    private static final String DEFAULT_VIDEO_NAME = "video";
    private static final String DEFAULT_THUMBNAIL_NAME = "thumbnail";

    @Value("${cloud.aws.s3.image.bucket}")
    private String bucket;

    @Value("${cloud.aws.s3.image.input-dir}")
    private String inputDir;

    @Value("${cloud.aws.s3.image.output-dir}")
    private String outputDir;

    private final AmazonS3 amazonS3;

    /**
     * upload video to "input" folder
     * @param multipartFileVideo
     * @return saved directory
     */
    public String uploadRawFile(MultipartFile multipartFileVideo, MultipartFile multipartFileThumbnail) {
        final String videoUuid = createUuid();

        // upload video, thumbnail
        String fileLink = getKey(multipartFileVideo, videoUuid);
        String thumbnailLink = getKey(multipartFileThumbnail, videoUuid);
        log.info("fileLink:" + fileLink);
        log.info("thumbnailLink:" + thumbnailLink);
        upload(multipartFileVideo, fileLink);
        upload(multipartFileThumbnail, thumbnailLink);

        return videoUuid;
    }

    private String createUuid(){
        return UUID.randomUUID().toString();
    }

    /**
     * rename key(s3 path)
     */
    public String getKey(MultipartFile multipartFile, String videoUuid){
        String originalFilename =multipartFile.getOriginalFilename();
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        if(ext.equals("mp4")) return videoUuid+"/"+ DEFAULT_VIDEO_NAME +"."+ext;
        else return videoUuid+"/"+DEFAULT_THUMBNAIL_NAME+"."+ext;
    }

    public void upload(MultipartFile multipartFile, String key){
        try {
            InputStream inputStream = multipartFile.getInputStream();
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentLength(multipartFile.getSize());
            amazonS3.putObject(new PutObjectRequest(bucket, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead)); // public 권한으로 설정
        } catch(IOException e){
            e.printStackTrace();
        }
    }

    private boolean isAllowedExt(String ext) {
        for(String cur: ALLOWED_EXT){
            if(ext.equals(cur)){
                return true;
            }
        }
        return false;
    }

    public String uploadTranscodedFile(UploadResponseDto uploadResponseDto){
        String result1 = uploadTranscodedFile(uploadResponseDto.getOutputPath());
        String result2 = uploadTranscodedFile(uploadResponseDto.getTsPath());
        String result3 = uploadTranscodedFile(uploadResponseDto.getThumbnailPath());
        if(result1 == null || result2==null || result3==null) return null;
        return "success";
    }
    /**
     * s3에 업로드
     * - PutObjectRequest로 저장하는 방식이 추가로 로컬에 파일을 저장하지 않으므로 선호됨
     * - 따라서 InputStream 사용
     */
    public String uploadTranscodedFile(String path) {
        log.info("path:"+ path);
        File uploadFile = new File(path);
        try {
            if (uploadFile != null) {
                final String OUTPUT_FILEPATH = outputDir + "/" + uploadFile.getName();
                log.info("OUTPUT_FILEPATH:" + OUTPUT_FILEPATH);
                amazonS3.putObject(new PutObjectRequest(bucket, OUTPUT_FILEPATH, uploadFile)
                        .withCannedAcl(CannedAccessControlList.PublicRead)); // public 권한으로 설정

                return uploadFile.getName();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}