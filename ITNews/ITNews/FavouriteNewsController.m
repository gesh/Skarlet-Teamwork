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
}

static NSString *const EntityName = @"News";

static NSString *cellIdentifier = @"ArticleUITableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib* nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    [self loadData];
    
    //    //ADDING
    //    News* news1 = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:_cdHelper.context];
    //    news1.title = @"Test 1";
    //    news1.content = @"Content 1";
    //    news1.author = @"Author 1";
    //    news1.thumbUrl = @"https://images-na.ssl-images-amazon.com/images/G/01/srrichar/laptop_bg_acer.jpg";
    //    news1.videoUrl = @"https://www.youtube.com/watch?v=bEJLv7IN7UE";
    //
    //
    //    News* news2 = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:_cdHelper.context];
    //
    //    [_cdHelper.context insertObject:news1];
    //    [_cdHelper.context insertObject:news2];
    //    news2.title = @"Test 2";
    //    news2.content = @"Content 2";
    //    news2.author = @"Author 2";
    //    news2.thumbUrl = @"https://images-na.ssl-images-amazon.com/images/G/01/srrichar/laptop_bg_acer.jpg";
    //    news2.videoUrl = @"https://www.youtube.com/watch?v=bEJLv7IN7UE";
    //
    //    [self.cdHelper saveContext];
    
    //    //DELETE:
    //
    //    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EntityName];
    //    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    //    for (News *currentNews in fetchedObjects) {
    //        NSLog(@"Deleting Object '%@'", currentNews.title);
    //        [_cdHelper.context deleteObject:currentNews];
    //    }
    
    
    //step 2: fetch this data
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //
    //    if (cell == nil) {
    //        cell = [[ArticleUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    //    }
    
    News *newsObject = [fetchedObjects objectAtIndex:indexPath.row];
    UIImageView *thumb = cell.thumbLabel;
    [thumb setImage: [UIImage imageNamed:@"globe.png"]];  // todo: change pic
    
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
    // Do any additional setup after loading the view, typically from a nib.
    //step 1: Insert some data
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];
    
    // FETHICNG:
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EntityName];
    fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    [self.tableView reloadData];
    
    // for (News *currentNews in fetchedObjects) {
    //     NSLog(@"Fetched Object = %@", currentNews.title);
    // }
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
