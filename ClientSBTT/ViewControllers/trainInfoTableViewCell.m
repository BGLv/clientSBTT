//
//  trainInfoTableViewCell.m
//  ClientSBTT
//
//  Created by Bogdan Lviv on 9/2/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

#import "trainInfoTableViewCell.h"

static const NSInteger sitsInCar = 31;
@interface trainInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *fromToDestinationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *avaliableSeatsLabel;

@end


@implementation trainInfoTableViewCell

- (void)setCellInfo:(NSDictionary *)cellInfo{
    _cellInfo = cellInfo;
    [self updateUI];
}

-(void)updateUI{
    
    self.fromToDestinationsLabel.text = [NSString stringWithFormat: @"From: %@ - To: %@", self.cellInfo[@"departure"],self.cellInfo[@"destination"]];
    self.departureTimeLabel.text = self.cellInfo[@"departureDateTime"];
    self.arrivalTimeLabel.text = self.cellInfo[@"destinationDateTime"];
    self.avaliableSeatsLabel.text =  [@([(NSString *)self.cellInfo[@"numCars"] integerValue]*sitsInCar) stringValue];
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
