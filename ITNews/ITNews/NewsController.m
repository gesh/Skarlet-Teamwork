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
#import "FullArticleViewController.h"
#import "ArticleUITableViewCell.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsController ()

@end

@implementation NewsController {
    
    NSMutableArray *allNews;

}

static NSString *cellIdentifier = @"ArticleUITableViewCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    allNews = [[NSMutableArray alloc] init];
    
    UINib* nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
//    PFObject *itNew = [PFObject objectWithClassName:@"News"];
//    itNew[@"title"] = @"title";
//    itNew[@"author"] = @"author";
//    itNew[@"content"] = @"content";
//    itNew[@"videoUrl"] = @"www.youtube.com";
//    itNew[@"thumbUrl"] = @"www.thumb2.com";
//    [itNew saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"title"];
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
                
                NewsObject *currentNews = [[NewsObject alloc] initWithTitle:title andAuthor:author andContent:content andVideoUrl:videoUrl andThumbUrl:thumbUrl];
                
                //NSLog(@"%@", currentNews.title);
                
                [allNews addObject:currentNews];
            }
            [self.tableView reloadData];
            NSLog(@"%lu",(unsigned long)allNews.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return allNews.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArticleUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[ArticleUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
//    }
    
    NewsObject *newsObject = (NewsObject* )[allNews objectAtIndex:indexPath.row];
    NSLog(@"%@",newsObject.title);
    
    
    UIImageView *thumb = cell.thumbLabel;
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
//    
//    UILabel *titleLabel = (UILabel*) [self.view viewWithTag:2000];
//    UILabel *contentLabel = (UILabel*) [self.view viewWithTag:2500];
//    
//    [titleLabel setText: newsObject.title];
//    [contentLabel setText:newsObject.content];

    cell.titleLabel.text = newsObject.title;
    cell.contentLabel.text = newsObject.content;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFullArticle"]) {
        FullArticleViewController *destination = [segue destinationViewController];
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        NSLog(@"%ld",(long)ip.row);
        NSLog(@"%@", ((NewsObject*)allNews[ip.row]).title);
        [destination setArticleToShow:[allNews objectAtIndex:ip.row]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showFullArticle" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
