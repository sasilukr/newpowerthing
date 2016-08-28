//
//  MasterViewController.m
//  jobtracker
//
//  Created by Sasi Ruangrongsorakai on 8/27/16.
//  Copyright © 2016 com.sasiluk. All rights reserved.
//
#import "AppDelegate.h"

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Job.h"
#import "JobTableViewCell.h"
#import "PrototypeTableViewCell.h"
#import "AFNetworkActivityIndicatorManager.h"


@interface MasterViewController ()


@property BOOL isConnected;

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self
                          selector:@selector(startPubNub)
                              name:@"ApplicationDidReceiveDeviceTokenEvent"
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(updateStatus:)
                              name:@"TrackingStatusUpdated"
                            object:nil];
    });

    
    [self.tableView registerClass:[JobTableViewCell class] forCellReuseIdentifier:@"JobTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JobTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobTableViewCell"];

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.rightBarButtonItem = addButton;
    
   // [self.tableView registerClass:[PrototypeTableViewCell class] forCellReuseIdentifier:@"PrototypeTableViewCell"];

    self.objects = [[NSMutableArray alloc] init];
    
    Job *job1 = [[Job alloc] init];
    job1.customerId = 1;
    job1.customerName = @"Tiffany Lee";
    job1.address1 = @"8 Octavia Street";
    job1.address2 = @"San Francisco, CA 94102";
    job1.phone = @"415-708-8885";
    job1.task = @"Kitchen sink";
    job1.price = @"$290.00";
    job1.status = @"Appt This Morning";
    job1.buttonText = @"Hit the Road";
    job1.statusCode = 3;
    
    Job *job2 = [[Job alloc] init];
    job2.customerId = 2;
    job2.customerName = @"Michael Smith";
    job2.address1 = @"8 Octavia Street";
    job2.address2 = @"San Francisco, CA 94102";
    job2.phone = @"415-708-8885";
    job2.task = @"Toliet";
    job2.price = @"$210.00";
    job2.status = @"Appt This Afternoon";
    job2.buttonText = @"";
    job2.statusCode = 3;
    
    Job *job3 = [[Job alloc] init];
    job3.customerId = 3;
    job3.customerName = @"Michelle Williams";
    job3.address1 = @"8 Octavia Street";
    job3.address2 = @"San Francisco, CA 94102";
    job3.phone = @"415-708-8885";
    job3.task = @"Shower Clogged Boo";
    job3.price = @"$311.00";
    job3.status = @"Inspection on Sept 3";
    job3.buttonText = @"";
    job3.statusCode = 0;
    
    Job *job4 = [[Job alloc] init];
    job4.customerId = 3;
    job4.customerName = @"Doug Neilsen";
    job4.address1 = @"440 N Wolfe st";
    job4.address2 = @"Sunnyvale, CA 94085";
    job4.phone = @"415-708-8885";
    job4.task = @"Shower Clogged Boo";
    job4.price = @"$726.00";
    job4.status = @"Inspection on Sept 3";
    job4.buttonText = @"";
    
    Job *job5 = [[Job alloc] init];
    job5.customerId = 3;
    job5.customerName = @"Dan Martin";
    job5.address1 = @"440 N Wolfe st";
    job5.address2 = @"Sunnyvale, CA 94085";
    job5.phone = @"415-708-8885";
    job5.task = @"Shower Clogged Boo";
    job5.price = @"$726.00";
    job5.status = @"Quote Given";
    job5.buttonText = @"";
    
    Job *job6 = [[Job alloc] init];
    job6.customerId = 3;
    job6.customerName = @"Craig Hodnett";
    job6.address1 = @"440 N Wolfe st";
    job6.address2 = @"Sunnyvale, CA 94085";
    job6.phone = @"415-708-8885";
    job6.task = @"Shower Clogged Boo";
    job6.price = @"$726.00";
    job6.status = @"Billed on Aug 24";
    job6.buttonText = @"";
    
    [self.objects addObject:job1];
    [self.objects addObject:job2];
    [self.objects addObject:job3];
    [self.objects addObject:job4];
    [self.objects addObject:job5];
    [self.objects addObject:job6];
    [self.tableView reloadData];
    
    self.detailViewController = (DetailViewController *)[self.splitViewController.viewControllers lastObject];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateStatus:(NSNotification *)notification {
    
    Job *updatedJob = [notification object];
    for (Job *j in self.objects) {
        if (j.customerId == updatedJob.customerId) {
            j.status = updatedJob.status;
            break;
        }
    }
    [self.tableView reloadData];
}
#pragma mark - PubNub

- (void)startPubNub {
    if (self.isConnected) {
        return;
    }
    [self setDisconnectState];
    [self connectToPubNub];
}


- (void)setDisconnectState
{
    self.isConnected = NO;
}

- (void)disconnect
{
    [self setDisconnectState];
    [[[MyPubNub shared] pubnub] removeListener:self];
}



- (void)connectToPubNub {
    
    NSLog(@"Attempting to connected to pubnub started");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-2694ba43-a08d-4d5d-a9fa-8f5beb6cc869"
                                                                     subscribeKey:@"sub-c-cbf1439a-6cf1-11e6-9259-0619f8945a4f"];
    
    configuration.origin = @"pubsub.pubnub.com";
    configuration.uuid = [appDelegate.devicePushToken isEqualToString:@"unknownDeviceToken"]? nil : appDelegate.devicePushToken;

    
    [[MyPubNub shared] setPubnub:[PubNub clientWithConfiguration:configuration]];
    [[[MyPubNub shared] pubnub]  addListener:self];
    [[[MyPubNub shared] pubnub]  timeWithCompletion:^(PNResult *result, PNStatus *status) {
        
        if (!status || !status.isError) {
            NSLog(@"%s - SUCCESS: PubNub Config UUID %@",__FUNCTION__, [[[MyPubNub shared] pubnub] uuid]);
            self.isConnected = YES;
            // Because Pubnub opens a socket connection we decrement the total number of connections by 1 so
            // we dont always have a spinner showing in the corner
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                    [[[MyPubNub shared] pubnub] subscribeToChannels:@[@"jobtracker"] withPresence:NO];
           // [[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubConnected object:nil];
        } else {
            NSLog(@"%s - ERROR: PubNub Connection Failed! %@",__FUNCTION__, status);
            [self setDisconnectState];
          //  [[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubFailToConnect object:nil];
        }
    }];
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
    if (status.category == PNUnexpectedDisconnectCategory) {
        // This event happens when radio / connectivity is lost
        NSLog(@"%s - ERROR: Disconnect %@",__FUNCTION__, status);
        self.isConnected = NO;
       // [[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubDisconnected object:nil];
    } else if (status.category == PNConnectedCategory) {
        if (status.operation == PNSubscribeOperation) {
            if ([status.subscribedChannelGroups count] > 0) {
                // assume if the request is to subscribe to channel group when channel group json is included, this is CDE
                //[[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubSubscribedToGroupChannel object:nil];
            } else {
                
//                [self.pubnub subscribeToChannels:@[@"jobtracker"] withPresence:NO];
                //[[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubSubscribedToChannel object:nil];
            }
        }
    } else if (status.category == PNReconnectedCategory) {
        
        // Happens as part of our regular operation. This event happens when
        // radio / connectivity is lost, then regained.
        NSLog(@"%s - PN CONNECTED EVENT: %@",__FUNCTION__, status);
        self.isConnected = YES;
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        //[[NSNotificationCenter defaultCenter] postNotificationName:LVPubNubConnected object:nil];
    } else if (status.category == PNDecryptionErrorCategory) {
        
        // Handle messsage decryption error. Probably client configured to
        // encrypt messages and on live data feed it received plain text.
        NSLog(@"%s - ERROR: %@",__FUNCTION__, status);
    } else if (status.category == PNAccessDeniedCategory) {
        NSLog(@"%s - ERROR: PNAccessDeniedCategory %@",__FUNCTION__, [status errorData]);
    } else {
        NSLog(@"%s - ERROR: other error %@",__FUNCTION__, [status errorData]);
    }
    
}


- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult*)message {
    NSLog(@"%s - PubNub Message received %@", __FUNCTION__, message);
    NSDictionary *messageObject = [[[message data] message] objectForKey:@"data"];
    NSNumber *customerId = [messageObject objectForKey:@"customerId"];
    NSString *status = [messageObject objectForKey:@"status"];
    
    
    Job *j = [self.objects objectAtIndex:0];
    j.statusCode = j.statusCode++;
    j.status = @"Yay! Another happy customer!";
    
//    for (Job* j in self.objects) {
//        if ([j customerId] == [customerId integerValue]) {
//            j.status = status;
//            break;
//        }
//    }
    
    [self.tableView reloadData];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Job *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tbView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Job *object = self.objects[indexPath.row];
    
    static NSString *jobTableIdentifier = @"JobTableViewCell";
    
    JobTableViewCell *cell = (JobTableViewCell *)[tableView dequeueReusableCellWithIdentifier:jobTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.customerNameLabel.text = [object customerName];
    cell.statusLabel.text = [object status];
    cell.priceLabel.text = [object price];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
