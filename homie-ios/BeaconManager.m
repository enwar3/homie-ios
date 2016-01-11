//
//  BeaconManager.m
//  
//
//  Created by Andrew Shaw on 1/10/16.
//
//

#import "BeaconManager.h"
#import <EstimoteSDK/EstimoteSDK.h>

@interface BeaconManager () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *beaconManager;

@end

@implementation BeaconManager

- (id)init {
    if ((self = [super init])) {
        
        self.beaconManager = [[ESTBeaconManager alloc] init];
        self.beaconManager.delegate = self;
        
        [self.beaconManager requestAlwaysAuthorization];
        
        [self.beaconManager startMonitoringForRegion:[[CLBeaconRegion alloc]
                                                      initWithProximityUUID:[[NSUUID alloc]
                                                                             initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                      major:14472 minor:31397 identifier:@"monitored region"]];
        
        [[UIApplication sharedApplication]
         registerUserNotificationSettings:[UIUserNotificationSettings
                                           settingsForTypes:UIUserNotificationTypeAlert
                                           categories:nil]];
        
    }
    return self;
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody =
    @"Your gate closes in 47 minutes. "
    "Current security wait time is 15 minutes, "
    "and it's a 5 minute walk from security to the gate. "
    "Looks like you've got plenty of time!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

@end
