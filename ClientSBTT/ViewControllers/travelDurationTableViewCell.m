//
//  travelDurationTableViewCell.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 9/2/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "travelDurationTableViewCell.h"

@interface travelDurationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *trainNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelDurationLabel;


@end

@implementation travelDurationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
