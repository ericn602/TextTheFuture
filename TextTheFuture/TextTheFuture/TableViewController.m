//
//  TableViewController.m
//  FutureTextBeta
//
//  Created by Eric Nguyen on 8/17/15.
//  Copyright (c) 2015 Eric Nguyen. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
@interface TableViewController ()
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation TableViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSString *number = @"YOUR PHONE NUMBER";
    NSString *url = @"http://localhost:3000/users/";
    NSString *urlString = [url stringByAppendingString:number];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    NSData *jsonData = [theReply dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
    _messages = (NSMutableArray *) jsonObject;
    [self.tableView reloadData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)
connection
{
    //NSLog(@"response data - %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if ([_messages count] > 0)
        cell.text = [[[_messages objectAtIndex:indexPath.row] objectForKey:@"to"] stringByAppendingString:[[_messages objectAtIndex:indexPath.row] objectForKey:@"sent"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailViewController *detailViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    detailViewController.data = [_messages objectAtIndex:indexPath.row];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
