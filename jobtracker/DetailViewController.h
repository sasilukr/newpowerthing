//
//  DetailViewController.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Job *detailItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
- (IBAction)updateStatus:(id)sender;

@end

