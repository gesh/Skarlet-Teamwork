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

@interface FullArticleViewController ()

@end

@implementation FullArticleViewController


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConnectionInspector checkConnection];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.currentArticle.title;
    self.contentTextView.text = self.currentArticle.content;
    self.authorLabel.text = self.currentArticle.author;

    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.currentArticle.videoUrl, self.videoWebView.frame.size.width, self.videoWebView.frame.size.height];
    
    // Load the html into the webview
    [self.videoWebView loadHTMLString:html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArticleToShow:(NewsObject *)articleToShow {
    self.currentArticle = articleToShow;
}


@end
