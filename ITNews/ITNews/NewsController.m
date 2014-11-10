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
#import "ConnectionInspector.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsController ()

@end

@implementation NewsController {
    NSMutableArray *allNews;
    MBProgressHUD *hud;
}

static NSString *cellIdentifier = @"ArticleUITableViewCell";
static NSString *segueIdentifier = @"showFullArticle";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConnectionInspector checkConnection];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Loading.."];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    allNews = [[NSMutableArray alloc] init];
    
    UINib* nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    [self loadData];
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
    NewsObject *newsObject = (NewsObject* )[allNews objectAtIndex:indexPath.row];
    
    UIImageView *thumb = cell.thumbLabel;
    [thumb setImage: [UIImage imageNamed:@"world89.png"]];
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString: newsObject.thumbUrl]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        [thumb setImage: image];
                });
            }
        }
    });
    
    cell.titleLabel.text = newsObject.title;
    cell.contentLabel.text = newsObject.content;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:segueIdentifier]) {
        FullArticleViewController *destination = [segue destinationViewController];
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];

        [destination setArticleToShow:[allNews objectAtIndex:ip.row]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:segueIdentifier sender:self];
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

    
    [hud show:YES];
    
    __weak NewsController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
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
                [weakSelf.tableView reloadData];
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
    [ConnectionInspector checkConnection];
    [self loadData];
}

@end
