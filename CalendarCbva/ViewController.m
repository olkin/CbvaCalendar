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
@synthesize resultLabel = _resultLabel;
//@synthesize curDate = _curDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_curDate = [NSDate date];
    _curDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*45];
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
    
    [self changeResults];
    
}

-(void) changeResults{
    NSArray *newArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EventsCalendar" ofType:@"plist"]];
        
     _resultLabel.text = @"";
    
    for (int i = 0; i < [newArray count];i++)
    {
        NSDate *eventDate = [[newArray objectAtIndex:i]objectForKey:@"Date"];
        
        if ([self isEqualWithoutTime:eventDate toDate:_curDate])
        {
            NSString *eventId = [[[newArray objectAtIndex:i]objectForKey:@"Calendar Event id"] stringValue];
            _resultLabel.text = [_resultLabel.text stringByAppendingString:eventId];
        }
    }
    
    if ([_resultLabel.text isEqualToString:@""])
        _resultLabel.text = @"No results";
    
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

-(bool) isEqualWithoutTime:(NSDate *)date1 toDate:(NSDate *)date2{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd MM yyyy"];       //Remove the time part
    NSString *date1String = [df stringFromDate:date1];
    NSString *date2String = [df stringFromDate:date2];
    NSDate *date1FromString = [df dateFromString:date1String];
    NSDate *date2FromString = [df dateFromString:date2String];
    
    return [date1FromString isEqualToDate:date2FromString];
}




@end
