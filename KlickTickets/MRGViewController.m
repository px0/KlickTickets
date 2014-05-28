//
//  MRGViewController.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-17.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "MRGViewController.h"
#import "GenomeAuthenticator.h"
#import "TicketListViewModel.h"
#import "Ticket.h"

//MRGViewController
@interface MRGViewController ()
@property (strong, nonatomic) GenomeAuthenticator *genomeAuthenticator;
@property (strong, nonatomic) TicketListViewModel *ticketListViewModel;

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sectionKeys;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MRGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    NSError *error = nil;
	
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"ticketID" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
	
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
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
}

- (void) getTickets {
	self.ticketListViewModel = [TicketListViewModel new];
//	RAC(self, sections) = RACObserve(self.ticketListViewModel, sections);
//	RAC(self, sectionKeys) = RACObserve(self.ticketListViewModel, sectionKeys);
//	
//	RACSignal *sectionKeysSignal = RACObserve(self.ticketListViewModel, sectionKeys);
//	[[sectionKeysSignal
//	  throttle:0.5]
//	  subscribeNext:^(id x) {
//		[self.tableView reloadData];
//	}];
}


#pragma mark - nsscreencast
#pragma mark UITableViewDelegate methods


#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDate *lastUpdatedAt = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdatedAt"];
//    NSString *dateString = [NSDateFormatter localizedStringFromDate:lastUpdatedAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
//    if (nil == dateString) {
//        dateString = @"Never";
//    }
//    return [NSString stringWithFormat:@"Last Load: %@", dateString];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Ticket *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
	// UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	
	UILabel *ticketNumberLabel = (UILabel *)[cell viewWithTag:100];
	UILabel *ticketStatusLabel = (UILabel *)[cell viewWithTag:101];
	UILabel *ticketTitleLabel = (UILabel *)[cell viewWithTag:102];
	
	// Configure the cell...
	ticketTitleLabel.text = t.title;
	ticketStatusLabel.text = t.ticketStatusName;
	ticketNumberLabel.text = t.ticketID;
	
    return cell;
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
