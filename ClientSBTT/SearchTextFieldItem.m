//
//  SearchTextFieldItem.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/30/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "SearchTextFieldItem.h"
#import <UIKit/UIKit.h>

@interface SearchTextFieldItem ()



@end

@implementation SearchTextFieldItem


- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image
{
    if(self = [super init]){
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    if(self = [super init]){
    self.title = title;
    self.subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title{
    if (self=[super init]){
        self.title=title;
    }
    return self;
}

@end
