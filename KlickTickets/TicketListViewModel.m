//
//  TicketListViewModel.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "TicketListViewModel.h"

#import "TicketViewModel.h"
#import "Ticket.h"

@interface TicketListViewModel ()

@end


@implementation TicketListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sections = [NSMutableDictionary new];
		self.sectionKeys = [NSArray new];
		
		[self getTickets];
    }
    return self;
}


- (void) getTickets; {
	RACSignal *ticketsSignal = [TicketListViewModel getTicketsFromWebservice];
	
	@weakify(self);
	[ticketsSignal subscribeNext:^(NSArray *viewModels) {
		@strongify(self);
		
		self.sections = [NSMutableDictionary new];
		
		[[[viewModels
		  //filter out closed tickets
		  select:^BOOL(TicketViewModel *t) {
			  return ![t.TicketStatusName isEqualToString:@"closed"];
		  }]
		 //only find the ones belonging to openforme
		 select:^BOOL(TicketViewModel *t) {
			 return [t.GroupName isEqualToString:@"OpenForMe"];
		 }]
		 //create section if it doesn't exist and add that item to the section
		 each:^(TicketViewModel *t) {
			 NSMutableArray *sectionItems = self.sections[t.ProjectName];
			 sectionItems = sectionItems ? [NSMutableArray arrayWithArray:sectionItems] : [NSMutableArray new];
			 [sectionItems addObject:t];
			 self.sections[t.ProjectName] = sectionItems;
		 }];
		
		NSArray *keys = [self.sections allKeys];
		self.sectionKeys = [keys sortedArrayUsingComparator:^(id a, id b) {
			return [a compare:b options:NSNumericSearch];
		}];
	}];
}

+ (RACSignal *) getTicketsFromWebservice; {
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
