// package com.example.statusservice.exceptionhandler;
//
//import com.example.statusservice.exceptionhandler.customexception.CustomStatusException;
//import com.example.statusservice.utils.ClientMessaging;
//import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
//import org.springframework.stereotype.Controller;
//
//
//@Controller
//public class ExceptionController {
//
//    private static final String CHAT_DESTINATION="/topic/friends/";
//
//    @MessageExceptionHandler
//    public void handleException(CustomStatusException e){
//        ClientMessaging.publish(CHAT_DESTINATION + e.getUuid(),
//                new ErrorResponse(e.getErrorCode(), e.getMessage() + e.getUuid()));
//    }
//}
