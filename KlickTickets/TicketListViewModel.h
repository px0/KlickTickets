//
//  TicketListViewModel.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface TicketListViewModel : NSObject
//properties

//methods
+ (RACSignal *) getTicketsFromWebservice;
+ (void) updateTicket: (Ticket *)ticket;

+ (NSFetchRequest *)fetchRequest;
+ (NSFetchedResultsController *) fetchedResultsController;
@end
