//
//  TicketListViewModel.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-18.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ticket;

@interface TicketViewModel : NSObject

@property (nonatomic, copy) NSNumber *TicketID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *TicketStatusName;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *GroupName;

- (instancetype)initWithModel: (Ticket *)model;

+ (RACSignal *) getAll; 
@end


