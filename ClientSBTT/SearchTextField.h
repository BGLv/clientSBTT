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

@interface SearchTextField : UITextField <UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic) NSString * startFilteringAfter;

/// If startFilteringAfter is set, and startSuggestingImmediately is true, the list of suggestions appear immediately
@property (nonatomic) BOOL startSuggestingImmediately;


//Set the result list's header
@property (nonatomic) UIView *resultsListHeader;

//force the result list to adapt to RTL languages
@property (nonatomic) BOOL forceRightToLeft;


//When InlineMode is true, the suggestion appear in the same line that the entered string. It's useful for email domain suggestion for example.
@property (nonatomic) BOOL inlineMode;


//Allow to decide the comparision options
@property (nonatomic) NSStringCompareOptions comparisonOptions;


//closure to handle when user stops typing
typedef void(^STFTypingHandlerBlock)(void);
@property (nonatomic,copy) STFTypingHandlerBlock userStoppedTypingHandler;

//closure to handle when the user pick an item
typedef void(^SearchTextFieldItemHandler)(NSMutableArray * filteredResults, NSInteger index);
@property (nonatomic, copy) SearchTextFieldItemHandler itemSelectionHandler;

//Handle text field changes
-(void)textFieldDidChange;
-(void)typingDidStop;

// Set an array of SearchTextFieldItem's to be used for suggestions
-(void)filterItems: (NSMutableArray *) items;


//Set an array of strings to be used for suggestions
-(void)filterStrings:(NSArray *) strings;

-(void)textFieldDidBeginEditing;
-(void)textFieldDidEndEditing;
-(void) textFieldDidEndEditingOnExit;


//Handle keyboard events
-(void)keyboardWillShow:(NSNotification *) notification;
-(void)keyboardWillHide:(NSNotification *) notification;
-(void)keyboardDidChangeFrame:(NSNotification *) notification;

//Min number of characters to start filtering
@property (nonatomic) NSInteger minCharactersNumberToStartFiltering;

//Force no filtering (display the entire filtered data source)
@property (nonatomic) BOOL forceNoFiltering;

//Move the table around to customize for your layout
@property (nonatomic) CGFloat tableXOffset;
@property (nonatomic) CGFloat tableYOffset;
@property (nonatomic) CGFloat tableCornerRadius;
@property (nonatomic) CGFloat tableBottomMargin;

@end

NS_ASSUME_NONNULL_END
