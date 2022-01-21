package com.example.userservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AmazonS3Service {
    private static final String CLOUD_FRONT_DOMAIN_NAME = "https://d8knntbqcc7jf.cloudfront.net/";
    private final AmazonS3 amazonS3;

    @Value("{cloud.aws.s3.bucket}")
    private String bucket;

    public String uploadRename(String fileName,String reName,String dirName) {
        /* TODO : CloudFront 이용, 버켓뒤 / 추가하여 폴더이름 추가 ex) profiles,thumbnail */
        S3Object o = amazonS3.getObject(new GetObjectRequest(bucket,fileName));
        S3ObjectInputStream objectInputStream = o.getObjectContent();
        delete(fileName);
        amazonS3.putObject(new PutObjectRequest(bucket,dirName+"/"+reName,objectInputStream,o.getObjectMetadata())
                .withCannedAcl(CannedAccessControlList.PublicRead));
        return getUrl(dirName,reName);
    }

    public String getUrl(String dirName,String fileName) throws CustomUserException {
        try {
            return CLOUD_FRONT_DOMAIN_NAME+dirName+"/"+fileName;
        } catch (CustomUserException e){
            throw new CustomUserException(ErrorCode.U006);
        }
    }

    public void delete(String fileName) {
        amazonS3.deleteObject(new DeleteObjectRequest(bucket,fileName));
    }
}
