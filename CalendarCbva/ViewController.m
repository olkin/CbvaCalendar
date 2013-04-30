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

//@synthesize dateLabel = _dateLabel;
//@synthesize dayOfTheWeekLabel = _dayOfTheWeekLabel;
//@synthesize curDate = _curDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_curDate = [NSDate date];
    _resultArray = [[NSMutableArray alloc] init];
    _curDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*45];
    _responseData = [NSMutableData data];
    _weatherDetails = [[NSMutableDictionary alloc] init];
    [self updateContent];
    
    //[self reloadWeather];
    [self reloadTeams];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateContent
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
    
    [self updateResults];
    
}

-(void) updateResults{
    
    [_resultTable reloadData];

    //[self reloadWeather];

}

/*
-(void) reloadWeather{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.wunderground.com/api/0b492bdf0241764b/conditions/q/YYC.json"]];
    // TODO: save connection?
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
 */

-(void) reloadTeams{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/teams.json"]];
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
    _resultArray = [[NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:&myError] mutableCopy];
    
    [self updateResults];
}

- (IBAction)swipedLeft {
    NSTimeInterval dayinseconds = -24 * 60 * 60;
    _curDate = [_curDate dateByAddingTimeInterval:dayinseconds];
    [self updateContent];
}

- (IBAction)swipedRight {
    NSTimeInterval dayinseconds = 24 * 60 * 60;
    _curDate = [_curDate dateByAddingTimeInterval:dayinseconds];
    [self updateContent];
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
    // show at least 1 row (No events row)
    if (tableView == _resultTable){
        return [_resultArray count] > 1? [_resultArray count]:1;
    }
    else
        return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _resultTable)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if([_resultArray count] > 0)
        {
            _resultTable.hidden = false;
            _noActivitiesLabel.hidden = true;
            NSDictionary *result = (NSDictionary*)[_resultArray objectAtIndex:indexPath.row];
            cell.textLabel.text = (NSString *) [result objectForKey:@"name"];
            cell.detailTextLabel.text = (NSString*)[result objectForKey:@"team_type"];
            
        }
        else
        {
            _resultTable.hidden = true;
            _noActivitiesLabel.hidden = false;
        }
        return cell;
    }
    else{
        
        static NSString *CellIdentifier = @"WeatherCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell;
        
        if ([indexPath row] == 0)
        {
            // DO in loop; program number of times
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            label.text = @"";
            
            label = (UILabel *)[cell viewWithTag:2];
            label.text = @"18:00";
            
            label = (UILabel *)[cell viewWithTag:3];
            label.text = @"19:00";
            
            label = (UILabel *)[cell viewWithTag:4];
            label.text = @"20:00";
            
            label = (UILabel *)[cell viewWithTag:5];
            label.text = @"";
            
        }
        
        return cell;
    }
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
