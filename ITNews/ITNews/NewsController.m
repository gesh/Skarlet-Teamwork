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
#import "AddArticleViewController.h"
#import "MBProgressHUD.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsController ()

@end

@implementation NewsController {
    
    NSMutableArray *allNews;
    MBProgressHUD *hud;

}

static NSString *cellIdentifier = @"ArticleUITableViewCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    allNews = [[NSMutableArray alloc] init];
    
    UINib* nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    [self loadData];
    
//    PFObject *itNew = [PFObject objectWithClassName:@"News"];
//    itNew[@"title"] = @"title";
//    itNew[@"author"] = @"author";
//    itNew[@"content"] = @"content";
//    itNew[@"videoUrl"] = @"www.youtube.com";
//    itNew[@"thumbUrl"] = @"www.thumb2.com";
//    [itNew saveInBackground];
    
}

- (void)insertNewObject:(id)sender {
    [self performSegueWithIdentifier:@"addArticle" sender:self];
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
    
    cell.titleLabel.text = newsObject.title;
    cell.contentLabel.text = newsObject.content;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFullArticle"]) {
        FullArticleViewController *destination = [segue destinationViewController];
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];

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

// shake gesture
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Exit"
                              message:@"Do you want to exit?"
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
     
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        exit(0);
    }
}


-(void) loadData {
    [allNews removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"title"];
    
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
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
                    
                    
                    [allNews addObject:currentNews];
                }
                [self.tableView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
    
    
}

- (IBAction)refreshButton:(id)sender {
    [self loadData];
}
@end
