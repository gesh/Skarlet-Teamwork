//
//  FavouriteNewsController.m
//  ITNews
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "FavouriteNewsController.h"
#import "CoreDataHelper.h"
#import "News.h"
#import "ArticleUITableViewCell.h"
#import "FullArticleViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface FavouriteNewsController ()

@property(nonatomic, strong) CoreDataHelper* cdHelper;

@end

@implementation FavouriteNewsController {
    NSMutableArray *fetchedObjects;
    News* selectedArticle;
}



static NSString *const EntityName = @"News";
static NSString *cellIdentifier = @"ArticleUITableViewCell";

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        [_cdHelper.context deleteObject: selectedArticle];
        [self.cdHelper saveContext];
        [self loadData];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Success"
                              message:@"Deleted successfully"
                              delegate: self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{

    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [pGesture locationInView:self.view];
        NSIndexPath* ip = [tableView indexPathForRowAtPoint:touchPoint];
        if (ip != nil) {
            
            selectedArticle = [fetchedObjects objectAtIndex: ip.row];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Exit"
                                  message:@"Do you want to delete this article?"
                                  delegate: self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
            
            [alert show];

            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib* nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    [self loadData];
   
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArticleUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    News *newsObject = [fetchedObjects objectAtIndex:indexPath.row];
    UIImageView *thumb = cell.thumbLabel;
    [thumb setImage: [UIImage imageNamed:@"world89.png"]];  // todo: change pic
    
    NSLog(@"%@", newsObject.thumbUrl);
    
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

-(void) loadData {
    
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EntityName];
    fetchedObjects = (NSMutableArray*)[_cdHelper.context executeFetchRequest:request error:nil];
    
    [self.tableView reloadData];

}

- (IBAction)refreshButton:(id)sender {
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFullFavoriteArticle"]) {
        FullArticleViewController *destination = [segue destinationViewController];
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        [destination setArticleToShow:[fetchedObjects objectAtIndex:ip.row]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showFullFavoriteArticle" sender:self];
}

@end
