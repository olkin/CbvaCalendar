//
//  ViewController.m
//  CalendarCbva
//
//  Created by Olga Pilipenco on 13-02-15.
//  Copyright (c) 2013 Olga Pilipenco. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize dateLabel = _dateLabel;
@synthesize dayOfTheWeekLabel = _dayOfTheWeekLabel;
//@synthesize curDate = _curDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _curDate = [NSDate date];
    [self changeLabelDates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) changeLabelDates
{
    // Do any additional setup after loading the view, typically from a nib.
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:_curDate];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:_curDate];
    
    _dateLabel.text = dateString;
    _dayOfTheWeekLabel.text = dayOfWeek;
    
}

- (IBAction)prevDayTouched {
    NSTimeInterval dayinseconds = -24 * 60 * 60;
    _curDate = [_curDate dateByAddingTimeInterval:dayinseconds];
    [self changeLabelDates];
    
}

- (IBAction)nextDayTouched {
    NSTimeInterval dayinseconds = 24 * 60 * 60;
    _curDate = [_curDate dateByAddingTimeInterval:dayinseconds];
    [self changeLabelDates];
}




@end
