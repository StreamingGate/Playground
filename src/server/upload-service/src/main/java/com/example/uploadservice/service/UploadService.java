package com.example.uploadservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

/**
 * Uplaod video file into AWS S3
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UploadService {

    @Value("${aws.s3.image.bucket}")
    private String bucket;

    @Value("${aws.s3.image.use-dir}")
    private String targetDir;

    private final AmazonS3 amazonS3;

    public String upload(MultipartFile multipartFile) {
        log.info("multipartFile name:" + multipartFile.getName()+ " " + multipartFile.getOriginalFilename());
        String fileName = targetDir+"/"+multipartFile.getName();
        try {
            InputStream inputStream = multipartFile.getInputStream();
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentLength(multipartFile.getSize());
            amazonS3.putObject(new PutObjectRequest(bucket, fileName, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead)); // public 권한으로 설정
        }catch (IOException e){
            e.printStackTrace();
        }
        return multipartFile.getName();
    }

    /**
     * s3에 업로드
     * - PutObjectRequest로 저장하는 방식이 추가로 로컬에 파일을 저장하지 않으므로 선호됨
     * - 따라서 InputStream 사용
     */
//    public String upload(File uploadFile, String filePath, String saveFileName) {
//        String fileName = filePath + "/" + saveFileName;
//        amazonS3.putObject(new PutObjectRequest(bucket, fileName, uploadFile)
//                .withCannedAcl(CannedAccessControlList.PublicRead)); // public 권한으로 설정
//
//        return fileName;
//    }
}