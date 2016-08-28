//
//  JobTableViewCell.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
// @property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;

@end
