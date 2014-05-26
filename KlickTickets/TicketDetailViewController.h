//
//  TicketDetailViewController.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *ticketDescription;
@property (weak, nonatomic) IBOutlet UITableView *actionTable;

@end
