//
//  FullArticleViewController.m
//  ITNews
//
//  Created by admin on 11/5/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "FullArticleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ConnectionInspector.h"
#import "CoreDataHelper.h"
#import "News.h"
#import "MBProgressHUD.h"
#import "ConnectionInspector.h"

@interface FullArticleViewController ()

@property(nonatomic, strong) CoreDataHelper* cdHelper;

@end

@implementation FullArticleViewController {
      MBProgressHUD *hud;
}

static NSString *const EntityName = @"News";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConnectionInspector checkConnection];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ConnectionInspector checkConnection];
     hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Loading.."];
    
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];
    
    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.currentArticle.videoUrl, self.videoWebView.frame.size.width, self.videoWebView.frame.size.height];
    
    // Load the html into the webview
    [self.videoWebView loadHTMLString:html baseURL:nil];
    self.titleLabel.text = self.currentArticle.title;
    self.contentTextView.text = self.currentArticle.content;
    self.authorLabel.text = self.currentArticle.author;
    
    [hud hide:YES afterDelay:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArticleToShow:(NewsObject *)articleToShow {
    self.currentArticle = articleToShow;
}

- (IBAction)addToFavorites:(id)sender {
    BOOL isAdded = NO;
    NSString *content = @"Already added to favourites!";
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EntityName];
    NSArray* fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];

    
     for (News *currentNews in fetchedObjects) {
         if([currentNews.title isEqualToString:self.currentArticle.title]){
             isAdded = YES;
             break;
         }
     }


    if(!isAdded){
        News* news1 = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:_cdHelper.context];
        news1.title = self.currentArticle.title;
        news1.content = self.currentArticle.content;
        news1.author = self.currentArticle.author;
        news1.thumbUrl = self.currentArticle.thumbUrl;
        news1.videoUrl = self.currentArticle.videoUrl;
        
        content = @"Article added successfully";
        
        [self.cdHelper saveContext];
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Favourite Articles"
                                                      message:content
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}


@end
