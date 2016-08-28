//
//  MasterViewController.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PubNub/PubNub.h>
#import <Foundation/Foundation.h>
#import "MyPubNub.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <PNObjectEventListener>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

