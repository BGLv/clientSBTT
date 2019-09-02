//
//  toOrderTicketTableViewCell.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 9/2/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "toOrderTicketTableViewCell.h"

@interface toOrderTicketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *placesInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *ticketForPlacePriceLabel;

@end


@implementation toOrderTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
