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

    }
    return self;
}

- (NSString* ) description {
	return [NSString stringWithFormat:@"<%@>: %@ (%@)", _model.TicketID, _model.Title, _model.TicketStatusName];
}

#pragma mark - Class methods
+ (RACSignal *) getAll; {
	RACSubject *viewModelsSignal = [RACSubject subject];
	
	NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [Ticket jsonMapping];
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
																							method:RKRequestMethodGET
																					   pathPattern:nil
																						   keyPath:@"Entries"
																					   statusCodes:statusCodeSet];
	
    NSURL *url = [NSURL URLWithString:@"http://genome.klick.com:80/api/Ticket.json?ForGrid=true"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSArray *ticketViewModels = [mappingResult.array map:^id(Ticket* t) {
			return [[TicketViewModel alloc] initWithModel:t];
		}];
		[viewModelsSignal sendNext:ticketViewModels];
		[viewModelsSignal sendCompleted];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
		[viewModelsSignal sendError:error];
    }];
    
    [operation start];
	
	return viewModelsSignal;
}
@end
