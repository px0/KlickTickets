//
//  Ticket.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-18.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject
@property (nonatomic, copy) NSNumber *TicketID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *TicketStatusName;
@property (nonatomic, copy) NSString *ProjectName;

+ (RKMapping *)jsonMapping;
@end

/*
 {
 "GroupName": "OpenForMe",
 "TicketID": 550533,
 "Title": "Investigate Xamarin",
 "Created": "/Date(1375895301613-0000)/",
 "ProjectID": 9991,
 "LastUpdated": "/Date(1398771837813-0000)/",
 "AccountPortfolioName": "Systems, Infrastructure, and Platform",
 "ProjectName": "smartsite v4",
 "CompanyID": 1,
 "CompanyName": "Klick Inc.",
 "AssignedToUser": "Max Gerlach",
 "AssignedByUser": "Cynthia Dahl",
 "OwnerUser": "Steve Willer",
 "TicketStatusName": "open"
 }
 */