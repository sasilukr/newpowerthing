//
//  SharedClient.m
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import "SharedClient.h"

@implementation SharedClient


NSString *twillioAccountSId = @"ACa81ee702388f927504bc037f1b93b9cf";
NSString *twillioAuthToken = @"b5337f94d31f046dadef2b26165532fc";

+ (instancetype)sharedClient
{
    static SharedClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        
        _sharedClient = [[SharedClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twilio.com/2010-04-01/Accounts/ACa81ee702388f927504bc037f1b93b9cf/Messages"]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.securityPolicy = securityPolicy;
    });
    
    return _sharedClient;
}

@end
