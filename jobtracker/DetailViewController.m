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
@property NSMutableArray *historyList;
@property NSMutableArray *currentHistoryList;
@property NSMutableArray *buttonStatusList;
@property NSMutableArray *textStatusList;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)setDetailItem:(Job *)newDetailItem {
    if (_detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        
        
        [self.historyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StatusHistoryViewCell"];
        
        self.historyList = [[NSMutableArray alloc] init];
        [self.historyList addObject:@"Inspection Scheduled 8/27"];
        [self.historyList addObject:@"Inspection Completed 8/28"];
        [self.historyList addObject:@"Service Scheduled 8/28"];
        [self.historyList addObject:@"Servicer en Route"];
        [self.historyList addObject:@"Service Begun 8/28"];
        [self.historyList addObject:@"Service Completed 8/28"];
        [self.historyList addObject:@"Bill Paid! 8/28"];
        [self.historyList addObject:@"Yay! Another happy customer!"];

        self.buttonStatusList = [[NSMutableArray alloc] init];
        [self.buttonStatusList addObject:@"Hit the Road"];
        [self.buttonStatusList addObject:@"Hit the Road"];
        [self.buttonStatusList addObject:@"Hit the Road"];
        [self.buttonStatusList addObject:@"Hit the Road"];
        [self.buttonStatusList addObject:@"I'm here!"];
        [self.buttonStatusList addObject:@"All done!"];
        [self.buttonStatusList addObject:@"Bill Reminder"];
        [self.buttonStatusList addObject:@":)"];

        
        self.textStatusList = [[NSMutableArray alloc] init];
        [self.textStatusList addObject:@"Status Text"];
        [self.textStatusList addObject:@"Status Text"];
        [self.textStatusList addObject:@"Status Text"];
        [self.textStatusList addObject:@"Appt This Morning"];
        [self.textStatusList addObject:@"On The Way"];
        [self.textStatusList addObject:@"On The Job"];
        [self.textStatusList addObject:@"Time to Get Paid"];
        [self.textStatusList addObject:@"Yay! Another happy customer!"];

        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = [self.detailItem customerName];
        
        [self.statusButton setTitle:[self.buttonStatusList objectAtIndex:self.detailItem.statusCode] forState:UIControlStateNormal];

        self.statusButton.backgroundColor = [UIColor colorWithRed:1 green:.73 blue:.15 alpha:1.0];
        self.statusButton.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        self.statusLabel.text = [self.textStatusList objectAtIndex:self.detailItem.statusCode];
        self.currentHistoryList = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < self.detailItem.statusCode ; i++) {
            [self.currentHistoryList addObject:[self.historyList objectAtIndex:i]];
        }
        
        [self.historyTableView reloadData];
        
        self.customerNameLabel.text = [self.detailItem customerName];
        self.address1Label.text = [self.detailItem address1];
        self.address2Label.text = [self.detailItem address2];
        self.phoneLabel.text = [self.detailItem phone];
        self.taskLabel.text = [self.detailItem task];
        self.priceLabel.text = [self.detailItem price];
        self.statusLabel.text = [self.detailItem status];
        
    }
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult*)message {
    NSLog(@"%s - PubNub Message received %@", __FUNCTION__, message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CHA-CHING"
                                                    message:@"You just got paid!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    NSDictionary *messageObject = [[[message data] message] objectForKey:@"data"];
    NSNumber *customerId = [messageObject objectForKey:@"customerId"];
    NSString *status = [messageObject objectForKey:@"status"];
    
    if ([self.detailItem customerId] == 1) {
        
        self.detailItem.statusCode = self.detailItem.statusCode+1;
        self.statusLabel.text = [self.textStatusList objectAtIndex:self.detailItem.statusCode];
        [self.currentHistoryList addObject:[self.historyList objectAtIndex:self.detailItem.statusCode-1]];
        [self.statusButton setTitle:[self.buttonStatusList objectAtIndex:self.detailItem.statusCode] forState:UIControlStateNormal];
        self.statusButton.backgroundColor = [UIColor colorWithRed:1 green:.73 blue:.15 alpha:1.0];
        self.statusButton.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        [self.historyTableView reloadData];
        
        self.detailItem.status = [self.textStatusList objectAtIndex:self.detailItem.statusCode];

    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[MyPubNub shared] pubnub] addListener:self];
    
    [self configureView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateStatus:(id)sender {

    
    self.detailItem.statusCode = self.detailItem.statusCode+1;
    self.statusLabel.text = [self.textStatusList objectAtIndex:self.detailItem.statusCode];
    [self.currentHistoryList addObject:[self.historyList objectAtIndex:self.detailItem.statusCode-1]];
    [self.statusButton setTitle:[self.buttonStatusList objectAtIndex:self.detailItem.statusCode] forState:UIControlStateNormal];
    self.statusButton.backgroundColor = [UIColor colorWithRed:1 green:.73 blue:.15 alpha:1.0];
    self.statusButton.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    [self.historyTableView reloadData];

    
    [self sendSms:self.detailItem.statusCode];
    self.detailItem.status = [self.textStatusList objectAtIndex:self.detailItem.statusCode];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"TrackingStatusUpdated" object:self.detailItem];
    
}

- (void)sendSms:(NSInteger) step {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"ACa81ee702388f927504bc037f1b93b9cf" password:@"b5337f94d31f046dadef2b26165532fc"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSString *textMessage = @"Blah";
    switch(step) {
        case 4:
            textMessage = @"On my way! http://bit.ly/2bPkB6S";
            break;
        case 5:
            textMessage = @"Getting started! http://bit.ly/2bZn4KZ";
            break;
        case 6:
            textMessage = @"All done! Pay me! http://bit.ly/2c6tMS2";
            break;
        
    }
    
    if (step == 6 || step == 4 || step == 5) {
        
        NSDictionary *params = @{@"From": @"+18056182783",
                                 @"To": @"+18057085558",
                                 @"Body": textMessage};
        [manager POST:@"https://api.twilio.com/2010-04-01/Accounts/ACa81ee702388f927504bc037f1b93b9cf/Messages.json"
           parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"JSON: %@", responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"Error: %@", error);
           }];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentHistoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *historyObject = self.currentHistoryList[indexPath.row];
    
    static NSString *jobTableIdentifier = @"StatusHistoryViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:jobTableIdentifier];
    
    if (cell == nil)
    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobTableViewCell" owner:nil options:nil];
//        cell = [nib objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:jobTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = historyObject;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
