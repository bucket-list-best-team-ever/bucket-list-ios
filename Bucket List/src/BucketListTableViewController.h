//
//  BucketListTableViewController.h
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{

    NSString *userID;
    NSString *selectedItemID;
    NSData *selectedItem;
    NSString *name;
}

@property (nonatomic, strong) NSMutableArray *bucketList;
@property (nonatomic, strong) NSDictionary *restData;

- (void) getUser;
- (void) getBucketList;

- (IBAction)addActionSheet:(id)sender;
- (IBAction)logOut : (id)sender;

@end

