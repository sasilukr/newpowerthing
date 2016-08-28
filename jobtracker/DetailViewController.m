//
//  DetailViewController.m
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DetailViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [self sendSms];
    } else if (selectedSegment == 1){
        NSLog(@"Select Started");
    }
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
