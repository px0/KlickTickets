//
//  Ticket+methods.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-28.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "Ticket+methods.h"

@implementation Ticket (methods)
+ (NSDictionary *) listMapping; {
	return @{
			 @"TicketID": @"ticketID",
			 @"Title": @"title",
			 @"TicketStatusName": @"ticketStatusName",
			 @"ProjectName": @"projectName",
			 @"GroupName": @"groupName",
			 };
}

+ (NSDictionary *) detailMapping; {
	return @{
			 @"TicketID": @"ticketID",
			 @"Description": @"body",
			 @"AssignedByUser": @"assigner",
			 };
}
@end
