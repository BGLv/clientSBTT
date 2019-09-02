//
//  DepartureTableViewController.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 8/27/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ModelController/connectionModelController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepartureTableViewController : UITableViewController <connProtoMC, UIScrollViewDelegate>

@property (nonatomic, strong) connectionModelController * connMC;

@end

NS_ASSUME_NONNULL_END
