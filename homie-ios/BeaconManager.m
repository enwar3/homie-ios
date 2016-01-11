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

@property (nonatomic, strong) CLBeaconRegion *exitRegion;
@property (nonatomic) BOOL wasNear;
@end

NSString *purpleID = @"purple beacon";
NSString *greenID = @"green beacon";
NSString *blueID = @"blue beacon";

@implementation BeaconManager

- (id)init {
    if ((self = [super init])) {
        
        self.purpleBeacon = [[CLBeaconRegion alloc]
                             initWithProximityUUID:[[NSUUID alloc]
                                                    initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                             major:143 minor:2 identifier:purpleID];
        self.greenBeacon = [[CLBeaconRegion alloc]
                            initWithProximityUUID:[[NSUUID alloc]
                                                   initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                            major:143 minor:3 identifier:greenID];
        self.blueBeacon = [[CLBeaconRegion alloc]
                           initWithProximityUUID:[[NSUUID alloc]
                                                  initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                           major:143 minor:1 identifier:@"blue region"];
        
        self.exitRegion = [[CLBeaconRegion alloc]
                           initWithProximityUUID:[[NSUUID alloc]
                                                  initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                           identifier:@"exit region"];
        
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

- (void)beginRanging {
    [self.beaconManager startRangingBeaconsInRegion:self.exitRegion];
}

- (void)endRanging {
    [self.beaconManager stopRangingBeaconsInRegion:self.exitRegion];
}

- (void)showLocalNotificationWithBody:(NSString *)body {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = body;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    NSLog(body);
}
#pragma mark - ESTBeaconManagerDelegate

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
    NSString *notification = [NSString stringWithFormat:@"------Did determine state for region: %@ state: %lu", [region identifier], (long)state];
    [self showLocalNotificationWithBody:notification];
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    
    NSString *notification = [NSString stringWithFormat:@"Entered beacon region: %@", [region identifier]];
    [self showLocalNotificationWithBody:notification];
    
    if ([region.identifier isEqualToString:blueID]) {
        [[ServerManager sharedInstance] serverCallWithAction:@"walkin"];
        
        // (TODO) enable beginRanging for more fine grained location triggers
//        [self beginRanging];
    }
    
}

- (void)beaconManager:(id)manager
        didExitRegion:(CLBeaconRegion *)region {
    if ([region.identifier isEqualToString:greenID]) {
        [[ServerManager sharedInstance] serverCallWithAction:@"walkout"];
    }
}

- (void)beaconManager:(id)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSString *notification = [NSString stringWithFormat:@"Beacon manager region error: %@", error];;
    [self showLocalNotificationWithBody:notification];
    
}

// Ranging options

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    
    NSString *notification = [NSString stringWithFormat:@"Now in region"];
    [self showLocalNotificationWithBody:notification];
    
    if (nearestBeacon) {
        // If near pruple, and proximity 
        if ([nearestBeacon.minor isEqualToNumber:self.purpleBeacon.minor]) {
            BOOL isSuperNear = nearestBeacon.proximity == CLProximityNear || nearestBeacon.proximity == CLProximityImmediate;
            if (isSuperNear && !self.wasNear) {
                [[ServerManager sharedInstance] serverCallWithAction:@"walkin"];
                
                NSString *notification = [NSString stringWithFormat:@"Super near: %@ proximity: %lu", nearestBeacon.minor, (long)nearestBeacon.proximity];;
                [self showLocalNotificationWithBody:notification];
                self.wasNear = YES;
            } else {
                self.wasNear = NO;
            }
        }
    }
}

@end
