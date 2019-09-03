//
//  toOrderTicketTableViewCell.h
//  ClientSBTT
//
//  Created by Bogdan Lviv on 9/2/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainSelectionTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface toOrderTicketTableViewCell : UITableViewCell <TrainSelection>
@property (nonatomic) NSDictionary *cellInfo;
@end

NS_ASSUME_NONNULL_END
