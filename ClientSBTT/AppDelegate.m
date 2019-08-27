//
//  AppDelegate.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "AppDelegate.h"
#import "connectionModelController.h"
#import "connectToServerViewController.h"
#import "ViewControllers/ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIViewController *rootController = self.window.rootViewController;
    //inject dependency to ViewController
    if([rootController isKindOfClass:[UINavigationController class]])
        rootController = [[(UINavigationController*)rootController childViewControllers] firstObject];
    if([rootController isKindOfClass:[connectToServerViewController class]]){
        connectToServerViewController *VC = (connectToServerViewController *) rootController;
        VC.connMC = [[connectionModelController alloc] init];
    }
    
    //Add observer to know of success login state
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToAfterLoginStoryboard) name:@"clientLoginSucceed" object:nil];
    
    return YES;
}

//delete all storyboard views and set new storyboard
-(void) goToAfterLoginStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"afterLogin" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    if (!viewController) {
        return;
    }
    //inject dependency to ViewController
    if([viewController isKindOfClass:[UINavigationController class]])
        viewController = [[(UINavigationController*)viewController childViewControllers] firstObject];
    if([viewController isKindOfClass:[ViewController class]]){
        ViewController *VC = (ViewController *) viewController;
        VC.connMC = [[connectionModelController alloc] init];
    }
    
    UIViewController *presentedViewController = [[[self window] rootViewController] presentedViewController];
    
    [presentedViewController presentViewController:viewController animated:YES completion:nil];
    
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController = viewController;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
