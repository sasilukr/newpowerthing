//
//  DetailViewController.m
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFNetworking.h>
#import "DetailViewController.h"
#import "MyPubNub.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Job *)newDetailItem {
    if (_detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = [self.detailItem customerName];
        int selectedIndex = 3;
        if ([[self.detailItem status] isEqualToString:@"omw"]) {
            selectedIndex = 0;
        } else if ([[self.detailItem status] isEqualToString:@"started"]) {
            selectedIndex = 1;
        } else if ([[self.detailItem status] isEqualToString:@"finished"]) {
            selectedIndex = 2;
        }
        [self.statusSegmentedControl setSelectedSegmentIndex:selectedIndex];
        
        self.customerNameLabel.text = [self.detailItem customerName];
        self.priceLabel.text = [self.detailItem price];
        self.taskLabel.text = [self.detailItem task];
        self.deadlineLabel.text = @"Today";
    }
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult*)message {
    NSLog(@"%s - PubNub Message received %@", __FUNCTION__, message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CHA-CHING"
                                                    message:@"You just got paid!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
//    SystemSoundID mBeep;
//    NSString* path = [[NSBundle mainBundle]
//                      pathForResource:@"Beep" ofType:@"aiff"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mBeep);
//    // Play the sound
//    AudioServicesPlaySystemSound(mBeep);
//    
//    // Dispose of the sound
//    AudioServicesDisposeSystemSoundID(mBeep);
//
    [alert show];
    
    NSDictionary *messageObject = [[[message data] message] objectForKey:@"data"];
    NSNumber *customerId = [messageObject objectForKey:@"customerId"];
    NSString *status = [messageObject objectForKey:@"status"];
    
    if ([self.detailItem customerId] == [customerId integerValue]) {
        
        int selectedIndex = 3;
        if ([status isEqualToString:@"omw"]) {
            selectedIndex = 0;
        } else if ([status isEqualToString:@"started"]) {
            selectedIndex = 1;
        } else if ([status isEqualToString:@"finished"]) {
            selectedIndex = 2;
        }
        [self.statusSegmentedControl setSelectedSegmentIndex:selectedIndex];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[MyPubNub shared] pubnub] addListener:self];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateStatus:(id)sender {
    NSInteger selectedSegment = self.statusSegmentedControl.selectedSegmentIndex;

    if (selectedSegment == 0) {
        NSLog(@"Select On The Way");
        self.detailItem.status = @"omw";
        [self sendSms];
    } else if (selectedSegment == 1) {
        self.detailItem.status = @"started";
        NSLog(@"Select Started");
    } else if (selectedSegment == 2) {
        self.detailItem.status = @"finished";
    } else if (selectedSegment == 3) {
        self.detailItem.status = @"paid";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TrackingStatusUpdated" object:self.detailItem];
    
}

- (void)sendSms {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"ACa81ee702388f927504bc037f1b93b9cf" password:@"b5337f94d31f046dadef2b26165532fc"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    
    NSDictionary *params = @{@"From": @"+18056182783",
                             @"To": @"+18057085558",
                             @"Body": @"Boring test message"};
    [manager POST:@"https://api.twilio.com/2010-04-01/Accounts/ACa81ee702388f927504bc037f1b93b9cf/Messages.json"
       parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
@end
