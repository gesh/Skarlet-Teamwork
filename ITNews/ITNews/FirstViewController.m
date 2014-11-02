//
//  FirstViewController.m
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "FirstViewController.h"

#import <Parse/Parse.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *itNew = [PFObject objectWithClassName:@"News"];
    itNew[@"title"] = @"title";
    itNew[@"author"] = @"author";
    itNew[@"content"] = @"content";
    itNew[@"videoUrl"] = @"www.youtube.com";
    itNew[@"thumbUrl"] = @"www.thumb2.com";
    [itNew saveInBackground];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"News"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            for (PFObject *new in objects) {
//                NSLog(@"%@", new);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
