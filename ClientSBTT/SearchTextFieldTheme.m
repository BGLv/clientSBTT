//
//  SearchTextFieldTheme.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/29/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "SearchTextFieldTheme.h"

@implementation SearchTextFieldTheme

- (CGFloat)borderWidth{
    if(!_borderWidth){
        _borderWidth=0;
    }
    return _borderWidth;
}

- (instancetype)initWidthCellHeigh: (CGFloat) cellHeigh backgroundColor: (UIColor *) bgColor borderColor: (UIColor*) borderColor borderWidth: (CGFloat) borderWidth separatorColor: (UIColor *)separatorColor font: (UIFont *)font fontColor: (UIColor *)fontColor subtitleFontColor: (UIColor *)subtitleFontColor placeholderColor: (UIColor *)placeholderColor
{
    self = [super init];
    if (self) {
        self.cellHeigh = cellHeigh;
        self.borderColor = borderColor;
        self.separatorColor = separatorColor;
        self.bgColor = bgColor;
        self.font = font;
        self.fontColor = fontColor;
        self.subtitleFontColor = subtitleFontColor ? subtitleFontColor : fontColor;
    }
    return self;
}

+ (SearchTextFieldTheme *)lightTheme{
    UIColor *backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0.6];
    UIColor *borderColor = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    return [[SearchTextFieldTheme alloc] initWidthCellHeigh:30 backgroundColor:backgroundColor borderColor:borderColor borderWidth:0 separatorColor:UIColor.clearColor font:[UIFont systemFontOfSize:10] fontColor:UIColor.blackColor subtitleFontColor:nil placeholderColor:nil];
}

+ (SearchTextFieldTheme *)darkTheme{
    UIColor *backgroundColor = [[UIColor alloc]initWithRed:0.8 green:0.8 blue:0.8 alpha:0.6];
    UIColor *borderColor = [[UIColor alloc] initWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    return [[SearchTextFieldTheme alloc] initWidthCellHeigh:30 backgroundColor:backgroundColor borderColor:borderColor borderWidth:0 separatorColor:UIColor.clearColor font:[UIFont systemFontOfSize:10] fontColor:UIColor.whiteColor subtitleFontColor:nil placeholderColor:nil];
}

@end
