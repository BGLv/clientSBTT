//
//  loginViewController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "loginViewController.h"
#import "connectionModelController.h"
#import "GDataXMLNode.h"
#import "createAccountViewController.h"
#import "ViewController.h"

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation loginViewController
- (IBAction)signInButtonPressed:(UIButton *)sender {
    GDataXMLElement *root = [GDataXMLNode elementWithName:@"root"];
    GDataXMLElement *command = [GDataXMLNode elementWithName:@"command"];
    [command addAttribute:[GDataXMLNode elementWithName:@"name" stringValue:@"Login"]];
    GDataXMLElement *username = [GDataXMLNode elementWithName:@"param1" stringValue:self.usernameTextField.text];
    GDataXMLElement *password = [GDataXMLNode elementWithName:@"param2" stringValue:self.passwordTextField.text];
    [command addChild:username];
    [command addChild:password];
    [root addChild:command];
    [self.connMC sendMessage:[root XMLString]];
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverAnswearParse:) name:@"answerReceivedSBTT" object:nil];
}

-(void)serverAnswearParse: (NSNotification *)notification{
    NSDictionary *answearDict = notification.userInfo;
    NSString *messageString = answearDict[@"message"];
    GDataXMLElement *answerXML = [[GDataXMLElement alloc]initWithXMLString:messageString error:nil];
    NSArray* errors = [answerXML elementsForName:@"errors"];
    if( [[errors firstObject] isKindOfClass:[GDataXMLElement class]]){
        NSString *errorsString = [(GDataXMLElement*)[errors firstObject] stringValue];
        if(0!=[errorsString length]){
            NSLog(@"Errors during login: %@", errorsString);
            return;
        }
    }
    //add Segue to viewController
    //[self performSegueWithIdentifier:@"toMainTabBarControllerSegue" sender:nil];
    
    //Nottify for suceed login
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"clientLoginSucceed" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.destinationViewController respondsToSelector:@selector(setConnMC:)]){
        [segue.destinationViewController setConnMC: self.connMC];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerReceivedSBTT" object:nil];

}

- (IBAction)createAccountButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"createAccountSegue" sender:sender];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerReceivedSBTT" object:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
