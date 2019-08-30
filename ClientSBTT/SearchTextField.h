//
//  SearchTextField.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/29/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTextFieldTheme;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Direction){
    down,
    up
};

@interface SearchTextField : UITextField

//maximum numbers of result to be shown in the suggestion list
@property (nonatomic) NSInteger * maxNumbersOfResults;

//maximum heigh of result list
@property (nonatomic) NSInteger * maxResultListHeigh;

//indicate if this field has been interracted with yet
@property (nonatomic) BOOL interactedWidth;//!!!!

//indicate if keyboard is showing or not
@property (nonatomic) BOOL keyboardIsShowind;

// how long to wait before deciding typing has stopped
@property (nonatomic) NSNumber * typingStoppedDelay;

//Set your custom visual theme, or just choose between pre-defined SearchTextFieldTheme.lightTheme() and searchTextField.darkTheme() themes
@property (nonatomic) SearchTextFieldTheme *theme;

//Show the suggestions list without filter when the text field is focused
@property (nonatomic) BOOL startVisible;

//Show the suggestions list without filter even if the text field is not focused
@property (nonatomic) BOOL startVisibleWithoutInteraction;

@property (nonatomic) NSMutableDictionary* highlightAttributes;



//Handle text field changes
-(void)textFieldDidChange;

@end

NS_ASSUME_NONNULL_END
