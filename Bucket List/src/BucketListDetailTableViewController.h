//
//  BucketListDetailTableViewController.h
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListDetailTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSString *userID;
    NSString *itemID;
    NSData   *selectedItem;
    NSString *title;
    NSString *isCompleted;
}

@property (nonatomic, strong) NSMutableArray *bucketListDetails;
@property (nonatomic, strong) NSDictionary *postData;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* completeButton;

- (void) getItemPosts;
- (void) setDetailsData: (NSString*) userID : (NSString*) itemID : (NSData*) selectedItem;
- (void) completeItem : (NSString*) completed;

- (IBAction)addActionSheet:(id)sender;
- (IBAction)completed : (id)sender;

@end

