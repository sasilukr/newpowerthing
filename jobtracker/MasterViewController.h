//
//  MasterViewController.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <PubNub/PubNub.h>
@class DetailViewController;

@interface MasterViewController : UITableViewController <PNObjectEventListener, PNObjectEventListener>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

