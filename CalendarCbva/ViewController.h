//
//  ViewController.h
//  CalendarCbva
//
//  Created by Olga Pilipenco on 13-02-15.
//  Copyright (c) 2013 Olga Pilipenco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfTheWeekLabel;
@property (nonatomic, retain)  NSDate *curDate;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

-(void) changeLabelDates;
-(void) changeResults;
-(bool) isEqualWithoutTime:(NSDate *)date1 toDate:(NSDate *)date2;

- (IBAction)nextDayTouched;
- (IBAction)prevDayTouched;

@end
