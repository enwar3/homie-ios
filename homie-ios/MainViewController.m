//
//  MainViewController.m
//  homie-ios
//
//  Created by Andrew Shaw on 1/10/16.
//  Copyright © 2016 dtl. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UITextFieldDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomieUserName"];
    self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"HomieUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
