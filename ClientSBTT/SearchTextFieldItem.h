//
//  SearchTextFieldItem.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/30/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
NS_ASSUME_NONNULL_BEGIN

@interface SearchTextFieldItem : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) UIImage* image;

-(void) initWithTitle: (NSString*) title subtitle: (NSString *)subtitle image: (UIImage *)image;

-(void) initWithTitle: (NSString*) title subtitle: (NSString *) subtitle;

-(void)initWithTitle: (NSString *)title;

@end

NS_ASSUME_NONNULL_END
