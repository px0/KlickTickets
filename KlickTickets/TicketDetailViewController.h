//
//  TicketDetailViewController.h
//  KlickTickets
//
//  Created by Maximilian Gerlach on 2014-05-19.
//  Copyright (c) 2014 Maximilian Gerlach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

@interface TicketDetailViewController : UIViewController

@property (strong, nonatomic) Ticket *ticket;
@end
