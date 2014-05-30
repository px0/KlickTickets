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
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) RETableViewManager* actionTableManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionTableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewHeightConstraint;
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
	NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
	
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
	//==================
	
	[self.ticketDescription loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://placekitten.com/300/300"]]];
	
	self.actionTableManager = [[RETableViewManager alloc] initWithTableView:self.actionTable];
	RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Test"];
    [_actionTableManager addSection:section];
	
	
	[@3 times:^{
		[section addItem:@"Just a simple NSString"];
	}];


	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.actionTableHeightConstraint.constant = self.actionTable.contentSize.height;
	
	CGFloat height = [[self.ticketDescription stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
	self.webviewHeightConstraint.constant = height;
	
	[self.view needsUpdateConstraints];
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
