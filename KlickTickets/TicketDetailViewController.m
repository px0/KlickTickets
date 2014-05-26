//
//  TicketDetailViewController.m
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "RETableViewManager.h"

@interface TicketDetailViewController ()
@property (strong, nonatomic) RETableViewManager* actionTableManager;
@end

@implementation TicketDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.ticketDescription loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://placekitten.com/900/900"]]];
	
	self.actionTableManager = [[RETableViewManager alloc] initWithTableView:self.actionTable];
	RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Test"];
    [_actionTableManager addSection:section];
	
[@3 times:^{
    [section addItem:@"Just a simple NSString"];
}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
