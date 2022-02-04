package com.example.uploadservice.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.S3Object;
import com.example.uploadservice.dto.UploadResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.bramp.ffmpeg.FFmpeg;
import net.bramp.ffmpeg.FFmpegExecutor;
import net.bramp.ffmpeg.FFprobe;
import net.bramp.ffmpeg.builder.FFmpegBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@Service
public class TranscodeService {

    private static final String S3_DOMAIN="https://s3.ap-northeast-2.amazonaws.com";
    private static final String DEFAULT_VIDEO_FILE = "video.mp4";
    private static final String DEFAULT_VIDEO_NAME = "video";

    @Value("${cloud.aws.s3.image.bucket}")
    private String bucket;

    @Value("${cloud.aws.s3.image.input-dir}")
    private String inputDir;

    @Value("${cloud.aws.s3.image.output-dir}")
    private String outputDir;

    private final AmazonS3 amazonS3;

    /**
     * @param videoUuid with s3 directory, ext(mp4)
     */
    public UploadResponseDto convertMp4ToTs(String videoUuid) {
        final String INPUT_FILEPATH = S3_DOMAIN+"/"+bucket+"/"+inputDir+"/"+videoUuid+"/" + DEFAULT_VIDEO_FILE;
        final String OUTPUT_FILEPATH = "C:\\Projects\\Playground\\bin";
//        final String FILENAME = rawFilename.split("\\.")[0];
//        final String EXT = rawFilename.split("\\.")[1];
        log.info("inputFilename:" + INPUT_FILEPATH);

        try {
                S3Object s3Object = amazonS3.getObject(bucket, inputDir+"/"+videoUuid+"/"+DEFAULT_VIDEO_FILE);
                if (s3Object == null) return null;
                FFmpeg ffmpeg = new FFmpeg("C:\\Program Files\\ffmpeg-5.0-essentials_build\\bin\\ffmpeg.exe");       //C:\Projects\Playground\bin\ffmpeg.exe
                FFprobe ffprobe = new FFprobe("C:\\Program Files\\ffmpeg-5.0-essentials_build\\bin\\ffprobe.exe");   //C:\Projects\Playground\bin\ffprobe.exe

                // ts file 생성
                FFmpegBuilder builder = new FFmpegBuilder()
                        .overrideOutputFiles(true) // 오버라이드 여부
                        .setInput(INPUT_FILEPATH) // 동영상파일
                        .addOutput(OUTPUT_FILEPATH + "/" + DEFAULT_VIDEO_NAME + ".m3u8")
                        .addExtraArgs("-profile:v", "baseline")
                        .addExtraArgs("-level", "3.0")
                        .addExtraArgs("-start_number", "0")
                        .addExtraArgs("-hls_time", "10")
                        .addExtraArgs("-hls_list_size", "0")
                        .addExtraArgs("-f", "hls")
                        .done();

                FFmpegExecutor excutor = new FFmpegExecutor(ffmpeg, ffprobe);
                excutor.createJob(builder).run();

                // 이미지 파일 생성
                FFmpegBuilder builderThumbNail = new FFmpegBuilder()
                        .overrideOutputFiles(true) // 오버라이드 여부
                        .setInput(INPUT_FILEPATH) // 동영상파일
                        .addExtraArgs("-ss", "00:00:03") // 썸네일 추출 시작점
                        .addOutput(OUTPUT_FILEPATH + "/" + "thumbnail" + ".png") // 썸네일 경로
                        .setFrames(1) // 프레임 수
                        .done();
                FFmpegExecutor executorThumbNail = new FFmpegExecutor(ffmpeg, ffprobe);
                executorThumbNail.createJob(builderThumbNail).run();


            return new UploadResponseDto(OUTPUT_FILEPATH +"/"+ DEFAULT_VIDEO_NAME + ".m3u8",
                    OUTPUT_FILEPATH +"/"+ DEFAULT_VIDEO_NAME + ".ts",
                    OUTPUT_FILEPATH + "/"+"thumbnail" + ".png");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
