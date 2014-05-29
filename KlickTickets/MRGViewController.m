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

    NSError *error = nil;
    // Setup fetched results
    self.fetchedResultsController = [TicketListViewModel fetchedResultsController];
    [self.fetchedResultsController setDelegate:self];
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
	if (!fetchSuccessful) {
		NSLog(@"Error while fetching results: %@", [error description]);
	}
	
	RAC(self,title) = [RACObserve(self.fetchedResultsController, fetchedObjects) map:^id(NSArray *objects) {
		if (objects) {
			return [NSString stringWithFormat:@"%d tickets", [objects count]];
		}
		else return @"No tickets";
	}];
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
		[TicketListViewModel getTicketsFromWebservice];
	}];
}

#pragma mark UITableViewDelegate methods


#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const reuseIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Ticket *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	UILabel *ticketNumberLabel = (UILabel *)[cell viewWithTag:100];
	UILabel *ticketStatusLabel = (UILabel *)[cell viewWithTag:101];
	UILabel *ticketTitleLabel = (UILabel *)[cell viewWithTag:102];
	
	// Configure the cell...
	ticketTitleLabel.text = t.title;
	ticketStatusLabel.text = t.ticketStatusName;
	ticketNumberLabel.text = t.ticketID;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	//http://stackoverflow.com/questions/2809192/core-data-fetchedresultscontroller-question-what-is-sections-for
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	Ticket *t = [sectionInfo.objects objectAtIndex:0];
	return t.projectName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
