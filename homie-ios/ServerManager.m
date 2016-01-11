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

- (void)serverCallWithID:(NSString *)name action:(NSString *)action {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/event/%@/%@", serverEnpoint, name, action]];
    NSLog(@"URL: %@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error,%@", [error localizedDescription]);
        }
        else {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
        }
    }];
}


@end
