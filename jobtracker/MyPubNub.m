//
//  MyPubNub.m
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/28/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import "MyPubNub.h"

@implementation MyPubNub
+ (instancetype)shared
{
    static MyPubNub *_lvPubNub;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lvPubNub = [[MyPubNub alloc] init];
    });
    return _lvPubNub;
}
@end
