//
//  WeatherControllerViewController.h
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIconImageView;
@property (weak, nonatomic) IBOutlet UITextView *weatherInfoTextView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender;

@end
