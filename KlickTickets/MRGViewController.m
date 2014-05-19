//
//  MRGViewController.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-17.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "MRGViewController.h"
#import "GenomeAuthenticator.h"
#import "TicketViewModel.h"
#import "TicketListViewModel.h"

//MRGViewController
@interface MRGViewController ()
@property (strong, nonatomic) GenomeAuthenticator *genomeAuthenticator;
@property (strong, nonatomic) TicketListViewModel *ticketListViewModel;

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sectionKeys;
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
}

- (void) getTickets {
	self.ticketListViewModel = [TicketListViewModel new];
	RAC(self, sections) = RACObserve(self.ticketListViewModel, sections);
	RAC(self, sectionKeys) = RACObserve(self.ticketListViewModel, sectionKeys);
	
	RACSignal *sectionKeysSignal = RACObserve(self.ticketListViewModel, sectionKeys);
	[[sectionKeysSignal
	  throttle:0.5]
	  subscribeNext:^(id x) {
		[self.tableView reloadData];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSString *key = [self.sectionKeys objectAtIndex:section];
    return [self.sections[key] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	TicketViewModel *tvm = [self.sections[[self.sectionKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
//	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	
	UILabel *ticketNumberLabel = (UILabel *)[cell viewWithTag:100];
	UILabel *ticketStatusLabel = (UILabel *)[cell viewWithTag:101];
	UILabel *ticketTitleLabel = (UILabel *)[cell viewWithTag:102];
	
	// Configure the cell...
	ticketTitleLabel.text = tvm.Title;
	ticketStatusLabel.text = tvm.TicketStatusName;
	ticketNumberLabel.text = [NSString stringWithFormat:@"%@", tvm.TicketID];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sectionKeys[section];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
