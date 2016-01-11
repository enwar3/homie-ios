//
//  BeaconManager.m
//  
//
//  Created by Andrew Shaw on 1/10/16.
//
//

#import "BeaconManager.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "ServerManager.h"

@interface BeaconManager () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *purpleBeacon;
@property (nonatomic, strong) CLBeaconRegion *greenBeacon;
@property (nonatomic, strong) CLBeaconRegion *blueBeacon;

@end

@implementation BeaconManager

- (id)init {
    if ((self = [super init])) {
        
        self.purpleBeacon = [[CLBeaconRegion alloc]
                             initWithProximityUUID:[[NSUUID alloc]
                                                    initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                             major:143 minor:2 identifier:@"purple region"];
        self.greenBeacon = [[CLBeaconRegion alloc]
                            initWithProximityUUID:[[NSUUID alloc]
                                                   initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                            major:143 minor:3 identifier:@"green region"];
        self.blueBeacon = [[CLBeaconRegion alloc]
                           initWithProximityUUID:[[NSUUID alloc]
                                                  initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                           major:143 minor:1 identifier:@"blue region"];
        
        self.beaconManager = [[ESTBeaconManager alloc] init];
        self.beaconManager.delegate = self;
        
        [self.beaconManager requestAlwaysAuthorization];
        
        [self.beaconManager startMonitoringForRegion:self.purpleBeacon];
        [self.beaconManager startMonitoringForRegion:self.greenBeacon];
        [self.beaconManager startMonitoringForRegion:self.blueBeacon];
        
        [[UIApplication sharedApplication]
         registerUserNotificationSettings:[UIUserNotificationSettings
                                           settingsForTypes:UIUserNotificationTypeAlert
                                           categories:nil]];
        
    }
    return self;
}

- (void)beaconManager:(id)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization status changed");
}


- (void)beaconManager:(id)manager
didStartMonitoringForRegion:(CLBeaconRegion *)region {
    NSLog(@"Started monitoring for region: %@", [region identifier]);
}

- (void)beaconManager:(id)manager
    didDetermineState:(CLRegionState)state
            forRegion:(CLBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = [NSString stringWithFormat:@"------Did determine state for region: %@ state: %lu", [region identifier], (long)state];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    NSLog(@"------Did determine state for region: %@ state: %lu", [region identifier], (long)state);
}


- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    NSLog(@"------Did enter region: %@", [region identifier]);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region: %@", [region identifier]];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [[ServerManager sharedInstance] didEnterRegion:@"andrew"];
    
}


- (void)beaconManager:(id)manager
        didExitRegion:(CLBeaconRegion *)region {
    
}

- (void)beaconManager:(id)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = [NSString stringWithFormat:@"Beacon manager region error: %@", error];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
