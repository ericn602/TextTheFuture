//
//  DetailViewController.m
//  FutureTextBeta
//
//  Created by Eric Nguyen on 8/17/15.
//  Copyright (c) 2015 Eric Nguyen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *toField;
@property (weak, nonatomic) IBOutlet UILabel *identification;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _messageField.text = [_data objectForKey:@"message"];
    _toField.text = [_data objectForKey:@"to"];
    _selectedDate = [_data objectForKey:@"when"];
    _identification.text = [_data objectForKey:@"name"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter dateFromString:[_data objectForKey:@"when"]];
    [_datePicker setDate:[dateFormatter dateFromString:[_data objectForKey:@"when"]]];
    if ([[_data objectForKey:@"sent"] isEqualToString:@" - Sent"]) {
        _updateButton.enabled = NO;
        _deleteButton.enabled = NO;
    }
}
- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:00'Z'"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    /*
     [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
     [dateFormatter setDateFormat:@"M/d/yy 'at' h:mma"];
     NSString* finalTime = [dateFormatter stringFromDate:newTime];
     NSLog(@"%@", finalTime);
     */
    _selectedDate = formattedDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)update:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/update"]];
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [_data objectForKey:@"from"], @"from",
                             [_data objectForKey:@"name"],@"id",
                             _messageField.text, @"message",
                             _selectedDate, @"when",
                             _toField.text, @"to",
                             @"no", @"delete",
                             nil];
    NSError *error;
    NSData *sentData = [NSJSONSerialization dataWithJSONObject:reqData options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:sentData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)delete:(id)sender {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/update"]];
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [_data objectForKey:@"from"], @"from",
                             [_data objectForKey:@"name"],@"id",
                             _messageField.text, @"message",
                             _selectedDate, @"when",
                             _toField.text, @"to",
                             @"yes", @"delete",
                             nil];
    NSError *error;
    NSData *sentData = [NSJSONSerialization dataWithJSONObject:reqData options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:sentData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
