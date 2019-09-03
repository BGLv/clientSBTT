//
//  toOrderTicketTableViewCell.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 9/2/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "toOrderTicketTableViewCell.h"

static const NSInteger sitsInCar = 31;

@interface toOrderTicketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *placesInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *ticketForPlacePriceLabel;

@end


@implementation toOrderTicketTableViewCell

- (void)setCellInfo:(NSDictionary *)cellInfo{
    _cellInfo = cellInfo;
    [self updateUI];
}

-(void)updateUI{
    NSString  *numCarsStr= [@([(NSString *)self.cellInfo[@"numCars"] integerValue]*sitsInCar) stringValue];
    self.placesInfoLabel.text = [NSString stringWithFormat: @"Seating 1 class \n %@ places", numCarsStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
