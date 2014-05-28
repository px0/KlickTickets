//
//  Ticket.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-26.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * ticketStatusName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * groupName;

@end
