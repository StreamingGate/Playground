// package com.example.statusservice.exception;
//
//import com.example.chatservice.utils.ClientMessaging;
//import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
//import org.springframework.stereotype.Controller;
//
//import static com.example.chatservice.exception.ErrorCode.C001;
//
//@Controller
//public class ExceptionController {
//
//    private static final String CHAT_DESTINATION="/topic/chat/room/";
//
//    @MessageExceptionHandler
//    public void handleException(CustomChatException e){
//        ClientMessaging.publish(CHAT_DESTINATION + e.getRoomId(), new ErrorResponse(C001, C001.getMessage()));
//    }
//}
