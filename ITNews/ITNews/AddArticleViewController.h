//
//  AddArticleViewController.h
//  ITNews
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbURLTextField;
@property (weak, nonatomic) IBOutlet UITextField *videoURLTextField;
- (IBAction)addArticleButton:(id)sender;

@end
