package com.example.userservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.example.userservice.exceptionhandler.customexception.CustomUserException;
import com.example.userservice.exceptionhandler.customexception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

@Component
@RequiredArgsConstructor
public class AmazonS3Service {
    private static final String CLOUD_FRONT_DOMAIN_NAME = "https://d8knntbqcc7jf.cloudfront.net/";
    private final AmazonS3 amazonS3;

    @Value("{cloud.aws.s3.bucket}")
    private String bucket;
    /* TODO: string으로 들어오는 data를 S3로 저장 */
    public String uploadRename(MultipartFile file, String reName,String dirName) throws IOException {
//        S3Object o = amazonS3.getObject(new GetObjectRequest(bucket,));
//        delete();
        amazonS3.putObject(new PutObjectRequest(bucket,reName, (File) null)
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

//    public File fileInput(String dirName, String fileName) throws IOException {
//        InputStream resource = new FileInputStream(CLOUD_FRONT_DOMAIN_NAME+dirName+"/"+fileName);
//        File convertFile = new File(fileName);
//        if (convertFile.createNewFile()) {
//            try (FileOutputStream fos = new FileOutputStream(convertFile)){
//                fos.write(resource.readAllBytes());
//            }
//            return convertFile;
//        }
//        return convertFile;
//    }
}
