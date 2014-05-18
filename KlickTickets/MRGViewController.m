//
//  MRGViewController.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-17.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "MRGViewController.h"
#import "GenomeAuthenticator.h"

//Ticket
@interface Ticket : NSObject
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *TicketStatusName;
@end

@implementation Ticket
@end

//MappingProvider
@interface MappingProvider : NSObject
+ (RKMapping *)ticketMapping;
@end

@implementation MappingProvider
+ (RKMapping *)ticketMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Ticket class]];
    [mapping addAttributeMappingsFromArray:@[@"Title", @"TicketStatusName"]];
    return mapping;
}
@end

//MRGViewController
@interface MRGViewController ()
@property (strong, nonatomic) GenomeAuthenticator *genomeAuthenticator;
@end

@implementation MRGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//authenticate
	self.genomeAuthenticator = [[GenomeAuthenticator alloc] init];
	@weakify(self);
	[[_genomeAuthenticator authenticate] subscribeNext:^(id authStatus) {
		BOOL authenticationSuccessful = [authStatus boolValue];
		if(! authenticationSuccessful) {
			@strongify(self);
			[self presentViewController:self.genomeAuthenticator animated:YES completion:NULL];
		}
	} error:^(NSError *error) {
		NSLog(@"An error has occured: %@", [error localizedDescription]);
	} completed:^{
		NSLog(@"You are now authenticated!");
		[self getTickets];
	}];
	
	//
}

- (void) getTickets {
	NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider ticketMapping];
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
		for (Ticket *t in mappingResult.array) {
			NSLog(@"t: %@ (%@)", t.Title, t.TicketStatusName);
		}
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
    }];
    
    [operation start];
}
@end
