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
#import "SearchTextFieldItem.h"

@interface SearchTextField()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *shadowView;
@property (nonatomic) Direction direction;
@property (nonatomic) CGFloat fontConversionRate;
@property (nonatomic) NSValue *keyboardFrameCGRect;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UILabel* placeholderLable;
/*@property (nonatomic, readonly) NSString *cellIdentifier;*/
+(NSString *)cellIdentifier; //fileprivate static let cellIdentifier = "APSSearchTextFieldCell"
@property (nonatomic, readonly) UIActivityIndicatorView* indicator;
@property (nonatomic) CGFloat maxTableViewSize;
@property (nonatomic) NSMutableArray *filteredResults;
@property (nonatomic) NSMutableArray *filterDatasource;
@property (nonatomic) UILabel *placeholderLabel;


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
        
        _startSuggestingImmediately = false;
        _forceRightToLeft=false;
        
        
        _inlineMode=false;
        _comparisonOptions = NSCaseInsensitiveSearch;
        
        //Move the table around to customize for your layout
        _tableXOffset = 0.0;
        _tableYOffset = 0.0;
        _tableCornerRadius = 2.0;
        _tableBottomMargin = 10.0;
        _forceNoFiltering = false;
        
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

- (void)setInlineMode:(BOOL)inlineMode{
    _inlineMode=inlineMode;
    if (true == inlineMode)
    {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
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

//Look for font attribute, at if it exist,adapt to the subtitle font size
- (NSMutableDictionary *)highlightAttributesForSubtile{
    NSMutableDictionary *highlightAttributesForSubtile = nil;
    
    for (NSAttributedStringKey key in self.highlightAttributes) {
        if (NSFontAttributeName==key){
            NSString *fontName = [[self.highlightAttributes objectForKey:key] fontName];
            CGFloat pointSize = [[self.highlightAttributes objectForKey:key] pointSize] * self.fontConversionRate;
            [highlightAttributesForSubtile setObject:[UIFont fontWithName:fontName size:pointSize] forKey:key];
        } else {
            [highlightAttributesForSubtile setObject:[self.highlightAttributes objectForKey:key] forKey:key];
        }
    }
    
    return highlightAttributesForSubtile;
}

-(void)filterForceShowAll:(BOOL)addAll{
    [self clearResults];
    
    if([self.text length]<self.minCharactersNumberToStartFiltering){
        return;
    }
    
    
    for (SearchTextFieldItem *item in self.filterDatasource) {
        if(!self.inlineMode){
            
            //find text in title and subtitle
            NSRange titleFilterRange = [(NSString *)item.title rangeOfString:self.text options:self.comparisonOptions];
            NSRange subtitleFilterRange = nil!= item.subtitle ? [item.subtitle rangeOfString:self.text options:self.comparisonOptions] : NSMakeRange(NSNotFound, 0);
            if (NSNotFound != titleFilterRange.location || NSNotFound != subtitleFilterRange.location || addAll){
                item.attributedTitle = [[NSMutableAttributedString alloc] initWithString:item.title];
                item.attributedSubtitle = [[NSMutableAttributedString alloc]initWithString: nil!=item.subtitle?item.subtitle:@""];
                
                [item.attributedTitle setAttributes:self.highlightAttributes range:titleFilterRange];
     
                if (NSNotFound!=subtitleFilterRange.location){
                    [item.attributedSubtitle setAttributes:[self highlightAttributesForSubtile] range:subtitleFilterRange];
                }
                
                [self.filteredResults addObject:item];
                
            }
        }else{
            NSString *textToFilter = [self.text lowercaseString];
            
            if(self.inlineMode && self.startFilteringAfter){
                NSString *suffixToFilter = [[textToFilter componentsSeparatedByString:self.startFilteringAfter] lastObject];
                if(nil!=suffixToFilter && (![@"" isEqual:suffixToFilter] || true == self.startSuggestingImmediately) && textToFilter!=suffixToFilter){
                    textToFilter = suffixToFilter;
                }else{
                    self.placeholderLabel.text = @"";
                    return;
                }
            }
            if ([[item.title lowercaseString] hasPrefix:textToFilter] ){
                NSString *itemSuffix = [item.title substringFromIndex:[textToFilter length]];
                item.attributedTitle = [[NSMutableAttributedString alloc] initWithString:itemSuffix];
                [self.filteredResults addObject:item];
            }
        }
    }
    [self.tableView reloadData];
    
    if(self.inlineMode){
        [self handleInlineFiltering];
    }
}

-(void)handleInlineFiltering{
    NSString *text = self.text;
    if (text) {
        if([text  isEqual: @""]){
            self.placeholderLabel.attributedText=nil;
        }else{
            SearchTextFieldItem* firstResult = [self.filteredResults firstObject];
            if(firstResult)
            {
                self.placeholderLabel.attributedText = firstResult.attributedTitle;
            }else{
                self.placeholderLabel.attributedText = nil;
            }
        }
    }
}

-(void) buildSearchTableView{
    
    if(!(self.tableView && self.shadowView)){
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.shadowView = [[UIView alloc] initWithFrame:CGRectZero];
        [self buildSearchTableView];
        return;
    }
    
    self.tableView.layer.masksToBounds = true;
    self.tableView.layer.borderWidth = self.theme.borderWidth > 0 ? self.theme.borderWidth : 0.5;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableHeaderView = self.resultsListHeader;
    if (self.forceRightToLeft){
        self.tableView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }
    
    self.shadowView.backgroundColor = UIColor.lightTextColor;
    self.shadowView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.shadowView.layer.shadowOffset = CGSizeZero;
    self.shadowView.layer.shadowOpacity = 1;
    
    //[self.window addSubview:self.tableView];//?????????? memory Leak ????
    __weak UITableView *weatTableView = self.tableView;
    [self.window addSubview:weatTableView];
    [self redrawSearchTableView];
    
}

//Re-set frames and theme colors
-(void)redrawSearchTableView{
    if (self.inlineMode){
        self.tableView.hidden=true;
        return;
    }
    
    UITableView *tableView = self.tableView;
    
    if (tableView) {
        CGRect frame = [self.superview convertRect:self.frame toView:nil];
        if(!self.superview){
            return;
        }
        
        //TableViews use estimated cell heights to calculate content size until they
        //  are on-screen. We must set this to the theme cell height to avoid getting an
        //  incorrect contentSize when we have specified non-standard fonts and/or
        //  cellHeights in the theme. We do it here to ensure updates to these settings
        //  are recognized if changed after the tableView is created
        tableView.estimatedRowHeight = self.theme.cellHeigh;
        if (self.direction == down){
            CGFloat tableHeight = 0;
            CGRect keyboardFrame;
            [self.keyboardFrameCGRect getValue:&keyboardFrame];
            if (self.keyboardIsShowind && self.keyboardFrameCGRect){
                tableHeight = MIN((tableView.contentSize.height),(UIScreen.mainScreen.bounds.size.height - frame.origin.y - frame.size.height -keyboardFrame.size.height));
            }else{
                tableHeight = MIN((tableView.contentSize.height),(UIScreen.mainScreen.bounds.size.height - frame.origin.y - frame.size.height));
            }
            
            if (self.maxResultListHeigh > 0){
                tableHeight = MIN(tableHeight, (CGFloat)*self.maxResultListHeigh);
            }
            
            //Set a bottom margin of 10p
            if (tableHeight < tableView.contentSize.height){
                tableHeight -= self.tableBottomMargin;
            }
            
            CGRect tableViewFrame = CGRectMake(0, 0, frame.size.width - 4, tableHeight);
            tableViewFrame.origin = [self convertPoint:tableViewFrame.origin toView:nil];
            tableViewFrame.origin.x += 2 + self.tableXOffset;
            tableViewFrame.origin.y += frame.size.height + 2 + self.tableYOffset;
            
            /*self.tableView.frame.origin = tableViewFrame.origin;*/
            /*! NO ANIMATION !!!!*/
            [self.tableView setFrame:tableViewFrame];
            
            CGRect shadowFrame = CGRectMake(0, 0, frame.size.width - 6, 1);
            shadowFrame.origin = [self convertPoint:shadowFrame.origin toView:nil];
            shadowFrame.origin.x += 3;
            shadowFrame.origin.y = tableView.frame.origin.y;
            [self.shadowView setFrame:shadowFrame];
        } else {
            const CGFloat tableHeight = MIN((tableView.contentSize.height), (UIScreen.mainScreen.bounds.size.height - frame.origin.y - self.theme.cellHeigh));
            __weak SearchTextField* weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^(){
                weakSelf.tableView.frame = CGRectMake(frame.origin.x + 2, (frame.origin.y - tableHeight), frame.size.width-4, tableHeight);
                weakSelf.shadowView.frame = CGRectMake(frame.origin.x + 3, frame.origin.y + 3, frame.size.width - 6, 1);
            }];
        }
        [self.superview bringSubviewToFront:self.tableView];
        [self.superview bringSubviewToFront: self.shadowView];
        
        if ([self isFirstResponder]){
            [self.superview bringSubviewToFront:self];
        }
        
        self.tableView.layer.borderColor = self.theme.borderColor.CGColor;
        self.tableView.layer.cornerRadius = self.tableCornerRadius;
        self.tableView.separatorColor = self.theme.separatorColor;
        self.tableView.backgroundColor = self.theme.bgColor;
        
        [self.tableView reloadData];
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
