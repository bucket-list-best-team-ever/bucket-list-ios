//
//  LogInViewController.m
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import "LogInViewController.h"
#import "BucketListTableViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    registerClicked = false;
}

- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    if (token)
        [self performSegueWithIdentifier:@"loginToBucketList" sender:nil];
}

- (void) logIn {
    
    NSString *url = @"https://bucket-list-be.herokuapp.com/api/login";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 
    NSDictionary *dict = @{@"email":_email.text,@"password": _password.text };

    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
 
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@", restData);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->registerClicked = true;
                
                self->_registerButton.hidden = YES;
                self->_nameText.hidden = NO;
                self->_nameText.text = @"";
                self->_email.text = @"";
                self->_password.text = @"";
                
                [self performSegueWithIdentifier:@"loginToBucketList" sender:nil];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[restData valueForKey:@"token"] forKey:@"token"];
                [defaults synchronize];
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

- (void) registerUser {
    
    NSString *url = @"https://bucket-list-be.herokuapp.com/api/register";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *dict = @{@"email":_email.text,@"password": _password.text, @"name": _nameText.text };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *restData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@", restData);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->registerClicked = true;
                
                self->_registerButton.hidden = YES;
                self->_nameText.hidden = NO;
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

- (IBAction) signInClicked:(id)sender{
    if (!registerClicked)
        [self logIn];
    else
        [self registerUser];
}

- (IBAction) registerClicked:(id)sender{
    
    if (!registerClicked)
    {
        registerClicked = true;
    
        [self->_registerButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self->_nameText.hidden = NO;
    
        [self->_signInButton setTitle:@"Register" forState:UIControlStateNormal];
        self->_email.text = @"";
        self->_password.text = @"";
        self->_nameText.text = @"";
    }
    else
    {
        registerClicked = false;
        
        [self->_registerButton setTitle:@"Sign Up" forState:UIControlStateNormal];
       
        self->_nameText.hidden = YES;
        
        [self->_signInButton setTitle:@"Log In" forState:UIControlStateNormal];
        self->_email.text = @"";
        self->_password.text = @"";
        self->_nameText.text = @"";
    }
}

@end
