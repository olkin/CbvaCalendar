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
    _responseData = [NSMutableData data];
    [self changeLabelDates];
    
    [self reloadWeather];
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
    //_temperatureLabel.text=@"";
    
    [self changeResults];
    
}

-(void) changeResults{
    // save the array not to load it every time
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
    
    //[self reloadWeather];

}

-(void) reloadWeather{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.wunderground.com/api/0b492bdf0241764b/conditions/q/YYC.json"]];
    // TODO: save connection?
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse*) response{
    NSLog(@"Did receive response");
    [_responseData setLength:0];
}

-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data{
    NSLog(@"Did receive data");
    [_responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Did Fail with error");
    NSLog(@"Connection failed with error %@", [error description]);
}

-(void) connectionDidFinishLoading:(NSURLConnection *)conenction{
    NSLog(@"Did Finish loading");
    NSLog(@"Succedded! Received %d bytes", [_responseData length]);
    
    // convert response to JSon
    NSError *myError = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:&myError];
   
    /*
    // show all values
    for (id key in result){
        id value = [result objectForKey:key];
        NSString *keyAsString = (NSString*)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"%@:%@", keyAsString, valueAsString);
    }
     */
    
    //NSInteger tempCelcius = [[result objectForKey:@"temp_c"] integerValue];
    //NSLog(@"Temp in C = %d", tempCelcius);
    NSDictionary* curDetails = [result objectForKey:@"current_observation"];
    NSInteger curTemp = [[curDetails objectForKey:@"temp_c"] integerValue];
    
    //NSLog(@"Temp:%d", curTemp);
    _temperatureLabel.text = [NSString stringWithFormat:@"%d C", curTemp];
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
    cell.textLabel.text = [self getEventNameById:[[result objectForKey:@"event id"] integerValue]];
    cell.detailTextLabel.text = (NSString*)[result objectForKey:@"Start time"];
    // Configure the cell.
    
    return cell;
}

-(NSString*) getEventNameById:(NSUInteger)eventId{
    // TODO: save the array not to load it every time
    NSArray *newArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Events" ofType:@"plist"]];

    for (int i = 0; i < [newArray count]; i++)
        if ([[[newArray objectAtIndex:i] objectForKey:@"Event ID"] integerValue] == eventId)
            return [[newArray objectAtIndex:i]objectForKey:@"Event Name"];
    
    return @"";
}




@end
