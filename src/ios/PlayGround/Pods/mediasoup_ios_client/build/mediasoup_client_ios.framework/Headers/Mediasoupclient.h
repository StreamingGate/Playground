//
//  Mediasoupclient.h
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "Logger.h"
#import "Device.h"
#import "Transport.h"
#import "Consumer.h"
#import "Producer.h"
#import "SendTransport.h"
#import "RecvTransport.h"
#import "RTCUtils.h"

#ifndef Mediasoupclient_h
#define Mediasoupclient_h

@interface Mediasoupclient : NSObject {}
/*!
    @returns The libmediasoupclient version
 */
+(NSString *)version;
/*! @brief Initializes the libmediasoupclient, initializes libwebrtc */
+(void)initializePC;
/*! @brief libmediasoupclient cleanup, cleans up libwebrtc */
+(void)cleanup;
@end

#endif /* Mediasoupclient_h */
