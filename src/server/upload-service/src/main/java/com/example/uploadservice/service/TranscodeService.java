package com.example.uploadservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.example.uploadservice.dto.VideoDto;
import com.example.uploadservice.exceptionHandler.customexception.CustomUploadException;
import com.example.uploadservice.exceptionHandler.customexception.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import net.bramp.ffmpeg.FFmpeg;
import net.bramp.ffmpeg.FFmpegExecutor;
import net.bramp.ffmpeg.FFprobe;
import net.bramp.ffmpeg.builder.FFmpegBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Slf4j
@Service
public class TranscodeService {

    private static final String DEFAULT_VIDEO_FILE = "video.mp4";
    private static final String DEFAULT_VIDEO_NAME = "video";
    private static final String DEFAULT_THUMBNAIL_NAME = "thumbnail";
    private final String S3_DOMAIN;
    private final String BUCKET;
    private final String INPUT_DIR;
    private final String LOCAL_FILEPATH;
    private final String FFMPEG_PATH;
    private final String FFPROBE_PATH;
    private final AmazonS3 amazonS3;

    @Autowired
    public TranscodeService(@Value("${cloud.aws.s3.image.domain}") String s3Domain,
                            @Value("${bin.path}") String localFilePath,
                            @Value("${cloud.aws.s3.image.bucket}") String bucket,
                            @Value("${cloud.aws.s3.image.input-dir}") String inputDir,
                            @Value("${ffmpeg.path}") String ffmpegPath,
                            @Value("${ffprobe.path}") String ffprobePath,
                            AmazonS3 amazonS3) {
        this.S3_DOMAIN= s3Domain;
        this.BUCKET = bucket;
        this.INPUT_DIR = inputDir;
        this.LOCAL_FILEPATH = localFilePath;
        this.FFMPEG_PATH = ffmpegPath;
        this.FFPROBE_PATH = ffprobePath;
        this.amazonS3 = amazonS3;
    }

    /**
     * @param videoUuid with s3 directory, ext(mp4)
     */
    public void convertMp4ToTs(String videoUuid, MultipartFile multipartFileThumbnail) throws CustomUploadException {
        final String INPUT_FILEPATH = S3_DOMAIN + "/" + BUCKET + "/" + INPUT_DIR + "/" + videoUuid + "/" + DEFAULT_VIDEO_FILE;
        log.info("FFMPEG_PATH " + FFMPEG_PATH);
        log.info("FFPROBE_PATH " + FFPROBE_PATH);

        // 폴더 생성
        File targetFolder = new File(LOCAL_FILEPATH + File.separator + videoUuid);
        if (targetFolder.mkdir()) {
            log.info("local folder has created... directory:" + videoUuid);
        } else {
            log.error("local folder cannot be created... directory:" + videoUuid);
            throw new CustomUploadException(ErrorCode.I001, "로컬에 임시 저장 폴더를 생성할 수 없습니다.");
        }

        try {
//            S3Object s3Object = amazonS3.getObject(BUCKET, INPUT_DIR + "/" + videoUuid + "/" + DEFAULT_VIDEO_FILE);
            FFmpeg ffmpeg = new FFmpeg(FFMPEG_PATH);       //C:\Projects\Playground\bin\ffmpeg.exe
            FFprobe ffprobe = new FFprobe(FFPROBE_PATH);   //C:\Projects\Playground\bin\ffprobe.exe

            // ts file 생성
            FFmpegBuilder builder = new FFmpegBuilder()
                    .overrideOutputFiles(true) // 오버라이드 여부
                    .setInput(INPUT_FILEPATH) // 동영상파일
                    .addOutput(LOCAL_FILEPATH + File.separator + videoUuid + File.separator
                            + DEFAULT_VIDEO_NAME + ".m3u8")
                    .addExtraArgs("-profile:v", "baseline")
                    .addExtraArgs("-level", "3.0")
                    .addExtraArgs("-start_number", "0")
                    .addExtraArgs("-hls_time", "10")
                    .addExtraArgs("-hls_list_size", "0")
                    .addExtraArgs("-f", "hls")
                    .done();

            FFmpegExecutor excutor = new FFmpegExecutor(ffmpeg, ffprobe);
            excutor.createJob(builder).run();

            if(multipartFileThumbnail == null) {
                // 이미지 파일 생성
                FFmpegBuilder builderThumbNail = new FFmpegBuilder()
                        .overrideOutputFiles(true)          // 오버라이드 여부
                        .setInput(INPUT_FILEPATH)           // 동영상파일
                        .addExtraArgs("-ss", "00:00:03")    // 썸네일 추출 시작점
                        .addOutput(LOCAL_FILEPATH + File.separator + videoUuid + File.separator
                                + DEFAULT_THUMBNAIL_NAME + ".png") // 썸네일 경로
                        .setFrames(1) // 프레임 수
                        .done();
                excutor.createJob(builderThumbNail).run();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
