//
//  SharedClient.h
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SharedClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
