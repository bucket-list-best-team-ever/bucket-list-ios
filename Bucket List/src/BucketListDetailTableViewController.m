//
//  BucketListDetailsTableViewController.m
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import "BucketListDetailTableViewController.h"

@interface BucketListDetailTableViewController ()

@end

@implementation BucketListDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) getItemPosts{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"https://bucket-list-be.herokuapp.com/api/item/%@/posts", itemID];
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
            self.postData  = [NSJSONSerialization JSONObjectWithData: data options:0 error: &parseError];
            NSLog(@"%@  status: %ld", self.postData, (long)httpResponse.statusCode);
            self.bucketListDetails  = [self.postData objectForKey:@"posts"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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

- (void) addNewPost : (NSString*) newPost{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = @"https://bucket-list-be.herokuapp.com/api/item/post";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *dict = @{@"message":newPost, @"item_id": self->itemID };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *postData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", postData, (long)httpResponse.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getItemPosts];
            });
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *postData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", postData, (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

- (void) completeItem : (NSString*) completed{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat: @"https://bucket-list-be.herokuapp.com/api/item/%@", self->itemID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *dict = @{@"user_id":self->userID, @"description": [self->selectedItem valueForKey:@"description"], @"completed": completed};
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *postData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", postData, (long)httpResponse.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getItemPosts];
            });
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *postData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@  status: %ld", postData, (long)httpResponse.statusCode);
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bucketListDetails.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *completed = @"completed";
    
    if ([self->isCompleted isEqualToString:@"0"]){
         completed = @"not completed";
        [self->_completeButton setTitle: @"Complete"];
    }
    else
        [self->_completeButton setTitle: @"Completed"];
    
    title = [NSString stringWithFormat:@"%@ %@", [self->selectedItem valueForKey:@"description"], completed];

    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *bucketListDetailsTemp = self.bucketListDetails[indexPath.row];
    
    NSString *name = bucketListDetailsTemp[@"message"];
    static NSString *cellIdentifier = @"bucketlistdetailcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = name;
    return cell;
}

- (void) setDetailsData: (NSString*) userID : (NSString*) itemID : (NSData*) selectedItem{
    self->userID = userID;
    self->itemID = itemID;
    self->selectedItem = selectedItem;
    

    self->isCompleted = @"1";
    
    long completedValue = [[self->selectedItem valueForKey:@"completed"] longValue];
    
    if (completedValue == 0)
       self->isCompleted = @"0";
 
    [self getItemPosts];
}


-(IBAction)addActionSheet:(id)sender{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Post" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"New Post";
    }];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = actionSheet.textFields;
        UITextField * newPost = textfields[0];
        [self addNewPost:newPost.text];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)completed : (id)sender{
    
    if ([self->isCompleted isEqualToString:@"0"])
        self->isCompleted = @"1";
    else
        self->isCompleted = @"0";
    
    [self completeItem: self->isCompleted];
}

@end
