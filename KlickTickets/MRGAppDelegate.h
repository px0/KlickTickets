//
//  MRGAppDelegate.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-17.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MRGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RKManagedObjectStore *objectStore;

@end
