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


- (void)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image
{
    self.title = title;
    self.subtitle = subtitle;
    self.image = image;
}

- (void)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    self.title = title;
    self.subtitle = subtitle;
}

- (void)initWithTitle:(NSString *)title{
    self.title=title;
}

@end
