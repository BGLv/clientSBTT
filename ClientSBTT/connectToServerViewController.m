//
//  connectToServerViewController.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "connectToServerViewController.h"
#import "connectionModelController.h"
#import "loginViewController.h"
@interface connectToServerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serverIpAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverPortTextField;

@end

@implementation connectToServerViewController

- (IBAction)connectButtonPressed:(UIButton *)sender
{
    if(NO==self.connMC.connected)
    {
        [self.connMC connectToServerWith:self.serverIpAddressTextField.text Port:self.serverPortTextField.text];
    }else{
        [self.connMC disconnectFromServer];
        [self.connMC connectToServerWith:self.serverIpAddressTextField.text Port:self.serverPortTextField.text];
    }
    /*if(YES==self.connMC.connected){
        [self performSegueWithIdentifier:@"toLoginVCSegue" sender:sender];
    }*/
}

-(void)connectedStartSegue{
     [self performSegueWithIdentifier:@"toLoginVCSegue" sender:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set radiostation
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectedStartSegue) name:@"connectedToSBTTServer" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[loginViewController class]]){
        loginViewController *loginVC = (loginViewController *)segue.destinationViewController;
        loginVC.connMC=self.connMC;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectedToSBTTServer" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectedToSBTTServer" object:nil];
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
