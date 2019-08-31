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

//warning! in Swift source this was private
@property (nonatomic) NSMutableAttributedString* attributedTitle;
@property (nonatomic) NSMutableAttributedString* attributedSubtitle;
//

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) UIImage* image;

-(void) initWithTitle: (NSString*) title subtitle: (NSString *)subtitle image: (UIImage *)image;

-(void) initWithTitle: (NSString*) title subtitle: (NSString *) subtitle;

-(void)initWithTitle: (NSString *)title;

@end

NS_ASSUME_NONNULL_END
