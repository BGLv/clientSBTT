//
//  DepartureTableViewController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/27/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "DepartureTableViewController.h"
#import "../GDataXML/GDataXMLNode.h"
#import "../SearchTextField.h"
#import "../SearchTextFieldTheme.h"
@interface DepartureTableViewController ()

@property (weak, nonatomic) IBOutlet SearchTextField *fromSearchTextField;
@property (weak, nonatomic) IBOutlet SearchTextField *toSearchTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;

@property (nonatomic) NSMutableDictionary *filterElementsArr;
@property (nonatomic) NSMutableArray *messageToSendQueue;

@end

@implementation DepartureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.fromSearchTextField filterStrings:@[@"Kiev",@"Lviv",@"Lutsk"]];
    //[self.toSearchTextField filterStrings:@[@"Kiev",@"Lviv",@"Lutsk"]];
    [self.fromSearchTextField setStartVisible:true];
    [self.toSearchTextField setStartVisible:true];
    self.fromSearchTextField.animationDuration=1.0;
    self.toSearchTextField.animationDuration=1.0;
    
    self.filterElementsArr = [[NSMutableDictionary alloc] init];
    self.messageToSendQueue = [[NSMutableArray alloc] init];
    
    //send message to server to get destinations suggestions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverAnswearParse:) name:@"answerReceivedSBTT" object:nil];
    [self.connMC sendMessage:[self createMessageToGetCurrentUserName]];
    __weak DepartureTableViewController *weakSelf=self;
    [self.messageToSendQueue addObject:^(){
        [weakSelf.connMC sendMessage:[weakSelf createMessageToGetDestinations]];
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    /*[[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerReceivedSBTT" object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverAnswearParse:) name:@"answerReceivedSBTT" object:nil];
}

- (IBAction)swapButtonPressed:(id)sender {
    [self.view endEditing:true];
}


-(NSString *)createMessageToGetCurrentUserName{
    GDataXMLElement *root = [GDataXMLNode elementWithName:@"root"];
    GDataXMLElement *command = [GDataXMLNode elementWithName:@"command"];
    [command addAttribute:[GDataXMLNode elementWithName:@"name" stringValue:@"GetCurrentUserName"]];
    [root addChild:command];
    return [root XMLString];
}

-(NSString *)createMessageToGetDestinations{
    GDataXMLElement *root = [GDataXMLNode elementWithName:@"root"];
    GDataXMLElement *command = [GDataXMLNode elementWithName:@"command"];
    [command addAttribute:[GDataXMLNode elementWithName:@"name" stringValue:@"GetDestinations"]];
    [root addChild:command];
    return [root XMLString];
}

-(void)serverAnswearParse: (NSNotification *)notification{
    NSDictionary *answearDict = notification.userInfo;
    NSString *messageString = answearDict[@"message"];
    GDataXMLElement *answerXML = [[GDataXMLElement alloc]initWithXMLString:messageString error:nil];
    NSArray* errors = [answerXML elementsForName:@"errors"];
    if( [[errors firstObject] isKindOfClass:[GDataXMLElement class]]){
        NSString *errorsString = [(GDataXMLElement*)[errors firstObject] stringValue];
        if(0!=[errorsString length]){
            NSLog(@"Errors: %@", errorsString);
            return;
        }
    }
    
    //if response has destinations we set it to fromSearchTextField and toSearchTextField properties
    NSArray *response = [answerXML elementsForName:@"response"];
    if( [[response firstObject] isKindOfClass:[GDataXMLElement class]]){
        NSArray *destinations = [(GDataXMLElement *)[response firstObject] elementsForName:@"destination"];
        
        for (id destination in destinations) {
            if([destination isKindOfClass:[GDataXMLElement class]]){
                NSString *destinationID = [[(GDataXMLElement *)destination attributeForName:@"id"] stringValue];
                NSString *destinationName = [[(GDataXMLElement *)destination attributeForName:@"name"]stringValue];
                [self.filterElementsArr setObject:destinationName forKey:destinationID];
                
                [self.fromSearchTextField filterStrings:[self.filterElementsArr allValues]];
                [self.toSearchTextField filterStrings:[self.filterElementsArr allValues]];
                
            }
        }
        
        void(^someMessageBlock)(void)=[self.messageToSendQueue lastObject];
        if(nil!=someMessageBlock)
            someMessageBlock();
        [self.messageToSendQueue removeLastObject];
    }
    
    
    
    
    //add Segue to viewController
    //[self performSegueWithIdentifier:@"toMainTabBarControllerSegue" sender:nil];
    
    //Nottify for suceed login
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.destinationViewController respondsToSelector:@selector(setConnMC:)]){
        [segue.destinationViewController setConnMC: self.connMC];
    }
    SEL infoToSearchTrainSel = NSSelectorFromString(@"setInfoToSearchTrain:");
    NSMutableDictionary *infoToSearchTrain = [[NSMutableDictionary alloc] init];
    
    if([segue.destinationViewController respondsToSelector:infoToSearchTrainSel]){
        //[segue.destinationViewController setDepartureDate: self.connMC];
        /*[segue.destinationViewController performSelector:setDepartureDate withObject:nil];*/
        SEL selector = NSSelectorFromString(@"setInfoToSearchTrain:");
        IMP imp = [segue.destinationViewController methodForSelector:selector];
        void (*func)(id, SEL, NSDictionary *) = (void *)imp;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:[self.dataPicker date]];
        [infoToSearchTrain setObject:stringFromDate forKey:@"departureDate"];
        NSString * keyFrom = [[self.filterElementsArr allKeysForObject: self.fromSearchTextField.text] firstObject];
        NSString * keyTo = [[self.filterElementsArr allKeysForObject: self.toSearchTextField.text] firstObject];
        [infoToSearchTrain setObject:keyFrom  forKey:@"from"];
        [infoToSearchTrain setObject:keyTo forKey:@"to"];
        func(segue.destinationViewController, selector, [infoToSearchTrain copy]);
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerReceivedSBTT" object:nil];
}


- (IBAction)hideKeyboardWhenDone:(id)sender {
    [self resignFirstResponder];
}




@end
