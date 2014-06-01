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
//IB outlets
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *actionTable;
@property (weak, nonatomic) IBOutlet UILabel *assigner;
@property (weak, nonatomic) IBOutlet UILabel *assignmentDate;
@property (weak, nonatomic) IBOutlet UILabel *ticketTitle;
@property (weak, nonatomic) IBOutlet UITextView *ticketBody;


@property (strong, nonatomic) RETableViewManager* actionTableManager;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionTableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ticketBodyHeightConstraint;
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

	RAC(self, title) = RACObserve(self.ticket, ticketID);
	RAC(self.ticketTitle, text) = RACObserve(self.ticket, title);
	RAC(self.assigner, text) = RACObserve(self.ticket, assigner);
	RAC(self.assignmentDate, text) = RACObserve(self.ticket, assigner);
	

	
	self.actionTableManager = [[RETableViewManager alloc] initWithTableView:self.actionTable];
	RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Test"];
    [_actionTableManager addSection:section];
	
	
	[@3 times:^{
		[section addItem:@"Just a simple NSString"];
	}];
	
	@weakify(self);
	[RACObserve(self.ticket, body) subscribeNext:^(NSString *ticketDescription) {
		@strongify(self);
		// http://stackoverflow.com/questions/2454067/display-html-text-in-uitextview
		NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[ticketDescription dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
		self.ticketBody.attributedText = attributedString;
		
		// http://stackoverflow.com/questions/18859637/setting-uitextview-frame-to-content-size-no-longer-works-in-xcode-5
		self.scrollView.scrollEnabled = YES; // This too was indicated as necessary if I want to get the correct size
		self.ticketBody.layoutManager.allowsNonContiguousLayout = NO; //Somehow, if I don't do this, i'm getting the wrong size
		CGRect textContainer = [[self.ticketBody layoutManager] usedRectForTextContainer:[self.ticketBody textContainer]];
		self.ticketBodyHeightConstraint.constant = ceil(textContainer.size.height);
		self.ticketBody.scrollEnabled = NO;
		
		[self.view setNeedsLayout];
	}];


}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
	
	// Pin the content view to the root view (jumping the scroll view).
	// This way the view doesn't shrink to only what i needed
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
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.actionTableHeightConstraint.constant = self.actionTable.contentSize.height;
	
//	
//	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.ticket.body dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//	self.ticketBody.attributedText = attributedString;
	
	
	[self.view setNeedsUpdateConstraints];
	[self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


@end
