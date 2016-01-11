//
//  ServerManager.m
//  homie-ios
//
//  Created by Andrew Shaw on 1/10/16.
//  Copyright © 2016 dtl. All rights reserved.
//

#import "ServerManager.h"


const NSString *serverEnpoint = @"http://8121f7f.ngrok.com";

@implementation ServerManager

+ (ServerManager *)sharedInstance {
    static ServerManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServerManager alloc] init];
    });
    return sharedInstance;
}

- (void)serverCallWithAction:(NSString *)action {
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HomieUserName"] lowercaseString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/event/%@/%@", serverEnpoint, username, action]];
    NSLog(@"URL: %@", url);
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error,%@", [error localizedDescription]);
        }
        else {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
        }
    }] resume];;
}


@end
