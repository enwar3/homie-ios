//
//  MainViewController.h
//  homie-ios
//
//  Created by Andrew Shaw on 1/10/16.
//  Copyright © 2016 dtl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;

- (IBAction)walkin:(id)sender;
- (IBAction)walkout:(id)sender;


@end
