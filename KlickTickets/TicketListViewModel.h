//
//  TicketListViewModel.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketListViewModel : NSObject
//properties
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sectionKeys;

//methods
- (void) getTickets;

+ (NSFetchRequest *)fetchRequest;
@end
