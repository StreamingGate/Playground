package com.example.userservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.*;
import java.util.Base64;

@Component
@RequiredArgsConstructor
public class AmazonS3Service {
    private static final String CLOUD_FRONT_DOMAIN_NAME = "https://d8knntbqcc7jf.cloudfront.net/";
    private static final String dirName = "profiles/";
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String upload(String data, String reName) throws CustomUserException {
        byte[] bytes = Base64.getDecoder().decode(data);
        InputStream inputStream = new ByteArrayInputStream(bytes);
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(bytes.length);
        metadata.setContentType("image/png");
        metadata.setCacheControl("public, max-age=31536000");
        amazonS3.putObject(new PutObjectRequest(bucket, dirName+reName, inputStream, metadata)
                .withCannedAcl(CannedAccessControlList.PublicRead));
        return getUrl(dirName,reName);
    }

    public String getUrl(String dirName,String fileName) throws CustomUserException {
        try {
            return CLOUD_FRONT_DOMAIN_NAME+dirName+fileName;
        } catch (CustomUserException e){
            throw new CustomUserException(ErrorCode.U006);
        }
    }

    public void delete(String fileName) throws CustomUserException {
        try {
            amazonS3.deleteObject(new DeleteObjectRequest(bucket,dirName+fileName));
        } catch (CustomUserException e) {
            throw new CustomUserException(ErrorCode.U006);
        }
    }

}
