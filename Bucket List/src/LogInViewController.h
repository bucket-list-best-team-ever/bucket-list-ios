//
//  LogInViewController.h
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LogInViewController : UIViewController{
    
    bool registerClicked;
    UITableViewController *bucketListTableView;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction) signInClicked:(id)sender;
- (IBAction) registerClicked:(id)sender;
- (void) logIn;

@end

