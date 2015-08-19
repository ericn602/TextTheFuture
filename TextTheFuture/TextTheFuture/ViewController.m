//
//  ViewController.m
//  FutureTextBeta
//
//  Created by Eric Nguyen on 8/15/15.
//  Copyright (c) 2015 Eric Nguyen. All rights reserved.
//

#import "ViewController.h"
@import AddressBook;
@interface ViewController ()
@property (strong, nonatomic) NSMutableData *responseData;
//@property (weak, nonatomic) IBOutlet UITextField *msg;
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *selectedDate;
@property (weak, nonatomic) IBOutlet UITextView *msg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self pickerAction:nil];
    

}
- (id) randomIDGen {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [s copy];
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
    NSLog(@"%@", _selectedDate);
}
- (IBAction)sendData:(id)sender {
    if (_msg.text.length <= 0 || _to.text.length <= 0) {
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"YourPhoneNumber", @"from",
                             (NSString *)[self randomIDGen],@"id",
                             _msg.text,@"message",
                             _selectedDate, @"when",
                             _to.text, @"to"
                               ,nil];
    NSError *error;
    NSData *sentData = [NSJSONSerialization dataWithJSONObject:reqData options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:sentData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    _msg.text = @"";
    _to.text = @"";
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"response data - %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
