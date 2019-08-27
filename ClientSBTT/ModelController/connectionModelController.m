//
//  connectionModelController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "connectionModelController.h"

@implementation connectionModelController 

- (void)connectToServerWith:(NSString *)ipAddr Port:(NSString *)port{
    NSLog(@"Setting up connection to %@ : %i", ipAddr, [port intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddr, [port intValue], &readStream,&writeStream);
    //messages = [[NSMutableArray alloc] init];
    if(_connected==NO)
        [self open];
}

-(void)open{
    NSLog(@"Opening streams.");
    outputStream = (__bridge NSOutputStream*)writeStream;
    inputStream = (__bridge NSInputStream*)readStream;
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
    //_connectedLabel.text = @"Connected";
}

- (void)disconnectFromServer{
    //if(YES==_connected)
        [self close];
}

- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    _connected = NO;
    // _connectedLabel.text = @"Disconnected";
}

-(void)sendMessage: (NSString *)messageToServer{
    NSData *data = [[NSData alloc] initWithData:[[messageToServer stringByAppendingString:@"\0"] dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)messageReceived: (NSString *)messageFromServer{
    NSDictionary *userInfo = @{
                               @"message" : messageFromServer
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"answerReceivedSBTT" object:nil userInfo:userInfo];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"Stream event %lu", eventCode);
    switch(eventCode){
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            _connected=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectedToSBTTServer" object:nil];
            break;
        case NSStreamEventHasBytesAvailable:
            if(aStream == inputStream){
                uint8_t buffer[1024];
                NSInteger len;
                
                while([inputStream hasBytesAvailable]){
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if(len>0){
                        NSString *output=[[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if(nil!=output){
                            NSLog(@"Server said: %@", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space avaliable");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@", [aStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            _connected=NO;
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
}


-(id)init{
    if(self = [super init]){
        _connected = NO;
    }
    return self;
}

@end
