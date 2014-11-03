//
//  FirstViewController.m
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//


#import <Parse/Parse.h>
#import "NewsController.h"
#import "NewsObject.h"
#import "NewsTableViewCell.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsController ()

@end

@implementation NewsController {
    
    NSMutableArray *allNews;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    allNews = [[NSMutableArray alloc] init];
    
    
//    PFObject *itNew = [PFObject objectWithClassName:@"News"];
//    itNew[@"title"] = @"title";
//    itNew[@"author"] = @"author";
//    itNew[@"content"] = @"content";
//    itNew[@"videoUrl"] = @"www.youtube.com";
//    itNew[@"thumbUrl"] = @"www.thumb2.com";
//    [itNew saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSString *title;
            NSString *author;
            NSString *content;
            NSString *videoUrl;
            NSString *thumbUrl;
            
            for (PFObject *temp in objects) {
                
                title = temp[@"title"];
                author = temp[@"author"];
                content = temp[@"content"];
                videoUrl = temp[@"videoUrl"];
                thumbUrl = temp[@"thumbUrl"];
                
                //NSLog(@"%@", content);
                
                NewsObject *currentNews = [[NewsObject alloc] initWithTitle:title andAuthor:author andContent:content andVideoUrl:videoUrl andThumbUrl:thumbUrl];
                [allNews addObject:currentNews];
            }
            NSLog(@"%lu",(unsigned long)allNews.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"news count");
    return [allNews count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
//    NewsTableViewCell *cel = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NewsObject *newsObject = (NewsObject* )[allNews objectAtIndex:indexPath.row];
    
    NSLog(@"%@", newsObject.title);
    
    UIImageView *thumb = (UIImageView*) [self.view viewWithTag:3000];
    [thumb setImage: [UIImage imageNamed:@"globe.png"]];  // todo: change pic
    
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString: newsObject.thumbUrl]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        [thumb setImage: image];                });
            }
        }
    });
    
    UILabel *titleLabel = (UILabel*) [self.view viewWithTag:2000];
    UILabel *contentLabel = (UILabel*) [self.view viewWithTag:2500];
    
    [titleLabel setText: newsObject.title];
    [contentLabel setText:newsObject.content];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
