//
//  BucketListTableViewController.m
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import "BucketListTableViewController.h"
#import "BucketListDetailTableViewController.h"

@interface BucketListTableViewController ()

@end

@implementation BucketListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self getUser];
}

- (void) viewWillAppear:(BOOL)animated{
     [self getUser];
}
 
- (void) getUser{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = @"https://bucket-list-be.herokuapp.com/api/user";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    [request setHTTPMethod:@"GET"];
   
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            self->userID = [[restData valueForKey:@"user"] valueForKey:@"id"];
            self->name   = [[restData valueForKey:@"user"] valueForKey:@"name"];
            [self getBucketList];
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", restData, (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

- (void) getBucketList{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"https://bucket-list-be.herokuapp.com/api/user/%@/items", self->userID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            self.restData  = [NSJSONSerialization JSONObjectWithData: data options:0 error: &parseError];
            NSLog(@"%@  status: %ld", self.restData, (long)httpResponse.statusCode);
            self.bucketList  = [self.restData objectForKey:@"items"];
            
            [self.view performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData: data options:0 error: &parseError];
            NSLog(@"%@  status: %ld", restData, (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

- (void) addNewItem : (NSString*) newItem{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = @"https://bucket-list-be.herokuapp.com/api/item";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];

    NSDictionary *dict = @{@"description":newItem, @"user_id": self->userID };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", restData, (long)httpResponse.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getBucketList];
            });
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", restData, (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bucketList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@ Bucket List", self->name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *bucketListTemp = self.bucketList[indexPath.row];
    
    NSString *name = bucketListTemp[@"description"];
    static NSString *cellIdentifier = @"bucketlistcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = name;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedItemID  = [[[self.restData objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"id"];
    selectedItem = [[self.restData objectForKey:@"items"] objectAtIndex:indexPath.row];
                    
    [self performSegueWithIdentifier:@"bucketListToDetailsSegue" sender:nil];
 
    NSLog(@"%ld", (long)indexPath.row);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"bucketListToDetailsSegue"])
    {
        BucketListDetailTableViewController *vc = [segue destinationViewController];
        
        [vc setDetailsData: userID: selectedItemID: selectedItem];
    }
}

-(IBAction)addActionSheet:(id)sender{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Item" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"New Item";
    }];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = actionSheet.textFields;
        UITextField * newItem = textfields[0];
        [self addNewItem:newItem.text];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)logOut : (id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"logOutSegue" sender:nil];
}

@end
