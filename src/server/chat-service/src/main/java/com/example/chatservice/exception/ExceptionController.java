package com.example.chatservice.exception;

import com.example.chatservice.utils.ClientMessaging;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.stereotype.Controller;

@Controller
public class ExceptionController {

    private static final String CHAT_DESTINATION="/topic/chat/room/";

    @MessageExceptionHandler
    public void handleException(CustomChatException e){
        ClientMessaging.publish(CHAT_DESTINATION + e.getUuid(),
                new ErrorResponse(e.getErrorCode(), e.getMessage()));
    }

}

