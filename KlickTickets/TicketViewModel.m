//
//  TicketListViewModel.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-18.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "TicketViewModel.h"
#import "Ticket.h"

@interface TicketViewModel()
@property (strong, nonatomic) Ticket* model;
@end

@implementation TicketViewModel
- (instancetype)initWithModel: (Ticket *)model;
{
    self = [super init];
    if (self) {
        self.model = model;
		RAC(self, Title) = RACObserve(self.model, Title);
		RAC(self, TicketStatusName) = RACObserve(self.model, TicketStatusName);
		RAC(self, TicketID) = RACObserve(self.model, TicketID);
		RAC(self, ProjectName) = RACObserve(self.model, ProjectName);
		RAC(self, GroupName) = RACObserve(self.model, GroupName);

    }
    return self;
}

- (NSString* ) description {
	return [NSString stringWithFormat:@"<%@>: %@ (%@)", _model.TicketID, _model.Title, _model.TicketStatusName];
}

#pragma mark - Class methods

@end
