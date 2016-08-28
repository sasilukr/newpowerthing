//
//  DetailViewController.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//
#import <PubNub/PubNub.h>
#import <UIKit/UIKit.h>
#import "Job.h"

@interface DetailViewController : UIViewController <PNObjectEventListener, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Job *detailItem;



@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *address1Label;
@property (strong, nonatomic) IBOutlet UILabel *address2Label;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
- (IBAction)updateStatus:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;

//@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
//
//@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
//- (IBAction)updateStatus:(id)sender;

@end

