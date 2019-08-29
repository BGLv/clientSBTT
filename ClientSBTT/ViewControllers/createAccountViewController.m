//
//  createAccountViewController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "createAccountViewController.h"
#import "connectionModelController.h"
#import "GDataXMLNode.h"
@interface createAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *patronymicTextField;

@end

@implementation createAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)closeButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serverAnswearParse:) name:@"answerReceivedSBTT" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"answerReceivedSBTT" object:nil];
}


- (IBAction)createAccountButtonPressed {
    if([self.passwordTextField.text isEqualToString:self.repeatPasswordTextField.text])
    {
        GDataXMLElement *root = [GDataXMLNode elementWithName:@"root"];
        GDataXMLElement *command = [GDataXMLNode elementWithName:@"command"];
        [command addAttribute:[GDataXMLNode elementWithName:@"name" stringValue:@"Register"]];
        [command addChild:[GDataXMLNode elementWithName:@"param1" stringValue:self.loginTextField.text]];
        [command addChild:[GDataXMLNode elementWithName:@"param2" stringValue:self.passwordTextField.text]];
        [command addChild:[GDataXMLNode elementWithName:@"param3" stringValue:self.surnameTextField.text]];
        [command addChild:[GDataXMLNode elementWithName:@"param4" stringValue:self.nameTextField.text]];
        [command addChild:[GDataXMLNode elementWithName:@"param5" stringValue:self.patronymicTextField.text]];
        [root addChild:command];
        
        [self.connMC sendMessage:[root XMLString]];
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password are not equal" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
    }
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
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Errors during login: %@", errorsString] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:okAction];
            [self presentViewController:alertC animated:YES completion:nil];
            return;
        }
    }
    //dissmissController
     [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)hideKeyboardWhenDone:(id)sender {
    [self resignFirstResponder];
}

@end
