//
//  MyPubNub.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/28/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PubNub/PubNub.h>

@interface MyPubNub : NSObject

+ (instancetype)shared;
@property (nonatomic) PubNub *pubnub;

@end
