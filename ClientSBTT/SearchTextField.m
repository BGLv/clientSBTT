//
//  SearchTextField.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/29/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "SearchTextField.h"
#import "SearchTextFieldTheme.h"
#import <UIKit/UIKit.h>


@interface SearchTextField()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *shadowView;
@property (nonatomic) Direction direction;
@property (nonatomic) CGFloat fontConversionRate;
@property (nonatomic) CGRect keyboardFrame;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UILabel* placeholderLable;
/*@property (nonatomic, readonly) NSString *cellIdentifier;*/
+(NSString *)cellIdentifier; //fileprivate static let cellIdentifier = "APSSearchTextFieldCell"
@property (nonatomic, readonly) UIActivityIndicatorView* indicator;
@property (nonatomic) CGFloat maxTableViewSize;
@property (nonatomic) NSMutableArray *filteredResults;
@property (nonatomic) NSMutableArray *filterDatasource;



@end


@implementation SearchTextField

+ (NSString *)cellIdentifier{
    
    return @"APSearchTextFieldCell";
    
}
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
        //public
        _maxNumbersOfResults= 0;
        _maxResultListHeigh = 0;
        _interactedWidth=false;//!!!
        _keyboardIsShowind=false;
        _typingStoppedDelay = @0.8;
        _theme = [SearchTextFieldTheme lightTheme];
        _highlightAttributes = [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} mutableCopy]; /*_cellIdentifier=@"APSearchTextFieldCell";*/
        _startVisible = false;
        _startVisibleWithoutInteraction = false;
        
        //private
        _direction=down;
        _fontConversionRate = 0.7;
        _indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _maxTableViewSize = 0;
        _filteredResults = [[NSMutableArray alloc] init];
        _filterDatasource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setTheme:(SearchTextFieldTheme *)theme{
    _theme = theme;
    
    [self.tableView reloadData];
    
    if(theme.placeholderColor)
        if(self.placeholder){
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:self.placeholder}];//NSAttributedString.Key.foregroundColor
            
            self.placeholderLable.textColor = theme.placeholderColor;
            
        }
    UIFont *hightlightedFont = self.highlightAttributes[NSFontAttributeName];
    if(hightlightedFont){
        self.highlightAttributes[NSFontAttributeName] = [hightlightedFont fontWithSize:self.theme.font.pointSize];
    }
    
}

- (void)setStartVisibleWithoutInteraction:(BOOL)startVisibleWithoutInteraction{
    _startVisibleWithoutInteraction=startVisibleWithoutInteraction;
    if(startVisibleWithoutInteraction){
        [self textFieldDidChange];
    }
}

- (void)setFilterDatasource:(NSMutableArray *)filterDatasource{
    _filterDatasource=filterDatasource;
    [self filterForceShowAll: self.forceNoFiltering];
    [self buildSearchTableView];
    
    if(self.startVisibleWithoutInteraction){
        [self textFieldDidChange];
    }
}


- (void)textFieldDidChange{
    if(!self.inlineMode && self.tableView == nil){
        [self buildSearchTableView];
    }
    
    self.interactedWidth = true;
    
    //Detect pauses when typing
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.typingStoppedDelay doubleValue] target:self selector:@selector(typingDidStop) userInfo:self repeats:false];
    
    if( 0 == self.text.length){
        [self clearResults];
        [self.tableView reloadData];
        if(self.startVisible || self.startVisibleWithoutInteraction){
            [self filterForceShowAll:true];
        }
        self.placeholderLable.text=@"";
    }else{
        [self filterForceShowAll: self.forceNoFiltering];
        [self prepareDrawTableResult];
    }
    [self buildPlaceholderLabel];
}


//clean filtered results
-(void)clearResults{
    [self.filteredResults removeAllObjects];
    [self.tableView removeFromSuperview];
}

-(void)filterForceShowAll:(BOOL)addAll{
    [self clearResults];
    
    if([self.text length]<self.minCharactersNumberToStartFiltering){
        return;
    }
    
    
    for (SearchTextFieldItem *item in self.filterDatasource) {
        if(!self.inlineMode){
            
            //find text in title and subtitle
            NSRange *titleFilterRange = (NSString *)item
            
        }
    }
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
