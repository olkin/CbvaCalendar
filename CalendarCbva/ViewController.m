//
//  ViewController.m
//  CalendarCbva
//
//  Created by Olga Pilipenco on 13-02-15.
//  Copyright (c) 2013 Olga Pilipenco. All rights reserved.
//

#import "ViewController.h"

@interface DateResultsViewController ()

@end

@implementation DateResultsViewController

@synthesize dateLabel = _dateLabel;
@synthesize dayOfTheWeekLabel = _dayOfTheWeekLabel;
//@synthesize curDate = _curDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_curDate = [NSDate date];
    _resultArray = [[NSMutableArray alloc] init];
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
        
    [_resultArray removeAllObjects];
    
    for (int i = 0; i < [newArray count];i++)
    {
        NSDate *eventDate = [[newArray objectAtIndex:i]objectForKey:@"Date"];
        
        if ([self isEqualWithoutTime:eventDate toDate:_curDate])
        {
            [_resultArray addObject:[newArray objectAtIndex:i]];
        }
    }
    
    [_resultTable reloadData];
    
}

- (IBAction)swipedLeft {
    NSTimeInterval dayinseconds = -24 * 60 * 60;
    _curDate = [_curDate dateByAddingTimeInterval:dayinseconds];
    [self changeLabelDates];
}

- (IBAction)swipedRight {
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

// customize number of sections
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// customize number of rows
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *result = (NSDictionary*)[_resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[result objectForKey:@"event id"] stringValue];
    cell.detailTextLabel.text = (NSString*)[result objectForKey:@"Start time"];
    // Configure the cell.
    
    return cell;
}




@end
