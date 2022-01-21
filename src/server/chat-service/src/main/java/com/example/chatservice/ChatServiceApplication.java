package com.example.chatservice;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Profile;

@Slf4j
@SpringBootApplication
public class ChatServiceApplication {

	@Value("${spring.redis.host}")
	private static String redisHost;

	@Value("${spring.redis.port}")
	private static String redisPort;

	public static void main(String[] args) {
		SpringApplication.run(ChatServiceApplication.class, args);
		log.info("redisHost:"+ redisHost);
		log.info("redisPort:"+ redisPort);
	}
}
