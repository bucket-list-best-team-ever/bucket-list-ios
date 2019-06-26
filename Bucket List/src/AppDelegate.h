//
//  AppDelegate.h
//  Bucket List
//
//  Created by Christopher Riffle on 6/25/19.
//  Copyright © 2019 Christopher Riffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

