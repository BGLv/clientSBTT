//
//  SearchTextField.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/29/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        //init all property's
        _maxNumbersOfResults= 0;
        _maxResultListHeigh = 0;
        _interractedWidth=false;//!!!
        _keyboardIsShowind=false;
        _typingStoppedDelay = @0.8;
        
    }
    return self;
}

-(NSInteger *)maxNumbersOfResults{
    if(nil ==_maxNumbersOfResults){
        _maxNumbersOfResults = 0;
    }
    return _maxNumbersOfResults;
}

- (NSInteger *)maxResultListHeigh{
    if(nil ==_maxResultListHeigh){
        _maxResultListHeigh = 0;
    }
    return _maxResultListHeigh;

}



@end
