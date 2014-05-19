//
//  Ticket.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-18.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

+ (RKMapping *)jsonMapping; {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Ticket class]];
    [mapping addAttributeMappingsFromArray:@[@"GroupName", @"ProjectName", @"TicketID", @"Title", @"TicketStatusName"]];
    return mapping;
}
@end
