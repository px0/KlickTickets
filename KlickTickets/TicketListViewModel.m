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

    }
    return self;
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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"projectName" ascending:NO];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ticketStatusName != 'closed' AND groupName == 'OpenForMe'"];
	[fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    return fetchRequest;
}

+ (NSFetchedResultsController *) fetchedResultsController {
	return [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest]
											   managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
												 sectionNameKeyPath:@"projectName"
														  cacheName:nil];
}
@end
