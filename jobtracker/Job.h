//
//  Job.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject

@property NSInteger customerId;
@property NSString *customerName;
@property NSString *status;
@property NSString *price;
@property NSDate *deadline;
@property NSString *task;
@end
