//
//  DetailViewController.h
//  homie-ios
//
//  Created by Andrew Shaw on 1/10/16.
//  Copyright © 2016 dtl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

