//
//  SearchTextFieldTheme.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/29/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTextFieldTheme : NSObject

@property (nonatomic) CGFloat cellHeigh;
@property (nonatomic) UIColor* bgColor;
@property (nonatomic) UIColor* borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor* separatorColor;
@property (nonatomic) UIFont* font;
@property (nonatomic) UIColor* fontColor;
@property (nonatomic) UIColor* subtitleFontColor;
@property (nonatomic) UIColor* placeholderColor;

+(SearchTextFieldTheme *) lightTheme;
+(SearchTextFieldTheme *) darkTheme;

@end

NS_ASSUME_NONNULL_END
