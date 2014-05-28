//
//  TicketListViewModel.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "TicketListViewModel.h"
#import "Ticket+methods.h"
#import "MRGAppDelegate.h"

#import <CoreData/CoreData.h>
#import "ObjectMapping.h"
#import "RKManagedObjectStore.h"
#import "RKManagedObjectImporter.h"
#import "RKManagedObjectMappingOperationDataSource.h"
#import "RKEntityMapping.h"
#import "RKManagedObjectCaching.h"
#import "RKInMemoryManagedObjectCache.h"
#import "RKFetchRequestManagedObjectCache.h"

#import "RKPropertyInspector+CoreData.h"
#import "NSManagedObjectContext+RKAdditions.h"
#import "NSManagedObject+RKAdditions.h"
#import "RKManagedObjectRequestOperation.h" 

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
	
	/*
	@weakify(self);
	[ticketsSignal subscribeNext:^(NSArray *viewModels) {
		@strongify(self);
		
		self.sections = [NSMutableDictionary new];
		
		[[[viewModels
		  //filter out closed tickets
		  select:^BOOL(Ticket *t) {
			  return ![t.ticketStatusName isEqualToString:@"closed"];
		  }]
		 //only find the ones belonging to openforme
		 select:^BOOL(Ticket *t) {
			 return [t.groupName isEqualToString:@"OpenForMe"];
		 }]
		 //create section if it doesn't exist and add that item to the section
		 each:^(Ticket *t) {
			 NSMutableArray *sectionItems = self.sections[t.projectName];
			 sectionItems = sectionItems ? [NSMutableArray arrayWithArray:sectionItems] : [NSMutableArray new];
			 [sectionItems addObject:t];
			 self.sections[t.projectName] = sectionItems;
		 }];
		
		NSArray *keys = [self.sections allKeys];
		self.sectionKeys = [keys sortedArrayUsingComparator:^(id a, id b) {
			return [a compare:b options:NSNumericSearch];
		}];
	}];
	 */
}

+ (RACSignal *) getTicketsFromWebservice; {
	RACSubject *viewModelsSignal = [RACSubject subject];
	
	NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Ticket"
                                                   inManagedObjectStore:AppDelegate.objectStore];
	[mapping addAttributeMappingsFromDictionary:[Ticket mapping]];
	
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
																							method:RKRequestMethodGET
																					   pathPattern:nil
																						   keyPath:@"Entries"
																					   statusCodes:statusCodeSet];
	
    NSURL *url = [NSURL URLWithString:@"http://genome.klick.com:80/api/Ticket.json?ForGrid=true"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request
                                                                                      responseDescriptors:@[responseDescriptor]];

	operation.managedObjectContext = AppDelegate.objectStore.mainQueueManagedObjectContext;
	operation.managedObjectCache = AppDelegate.objectStore.managedObjectCache;
	
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//		[viewModelsSignal sendNext:mappingResult.array];
		[viewModelsSignal sendCompleted];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
		[viewModelsSignal sendError:error];
    }];
    
    [operation start];
	
	return viewModelsSignal;
}

+ (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    return fetchRequest;
}
@end
