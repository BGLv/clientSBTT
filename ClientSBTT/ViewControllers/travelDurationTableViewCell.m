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

- (void)setCellInfo:(NSDictionary *)cellInfo{
    _cellInfo = cellInfo;
    [self updateUI];
}

-(void)updateUI{
    
    self.trainNameLabel.text = self.cellInfo[@"name"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *departureDateSting = self.cellInfo[@"departureDateTime"];
    NSString *destinationDateString = self.cellInfo[@"destinationDateTime"];
    NSDate *departureDateTime = [dateFormatter dateFromString: departureDateSting];
    NSDate *destinationDateTime = [dateFormatter dateFromString:destinationDateString];
    NSTimeInterval secondsBetween = [destinationDateTime timeIntervalSinceDate:departureDateTime];
    self.travelDurationLabel.text =[self stringFromTimeInterval:secondsBetween];
    
    /*self.fromToDestinationsLabel.text = [NSString stringWithFormat: @"From: %@ - To: %@", self.cellInfo[@"departure"],self.cellInfo[@"destination"]];
    self.departureTimeLabel.text = self.cellInfo[@"departureDateTime"];
    self.arrivalTimeLabel.text = self.cellInfo[@"destinationDateTime"];
    self.avaliableSeatsLabel.text =  [@([(NSString *)self.cellInfo[@"numCars"] integerValue]*sitsInCar) stringValue];*/
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    //NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld hours %02ld minutes", (long)hours, (long)minutes];
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
