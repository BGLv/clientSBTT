//
//  connectionModelController.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface connectionModelController : NSObject <NSStreamDelegate>{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@property (nonatomic) BOOL connected;

-(void)sendMessage: (NSString *)messageToServer;
-(void)connectToServerWith: (NSString *)ipAddr Port: (NSString *)port;
-(void)disconnectFromServer;

@end

@protocol connProtoMC <NSObject>

@required
-(connectionModelController *) connMC;
-(void) setConnMC:(connectionModelController *) connMC;

@end

NS_ASSUME_NONNULL_END
