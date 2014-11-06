//
//  FullArticleViewController.m
//  ITNews
//
//  Created by admin on 11/5/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "FullArticleViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FullArticleViewController ()

@end

@implementation FullArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.titleLabel.text = @"sadas";
    self.titleLabel.text = self.currentArticle.title;
    self.contentTextView.text = self.currentArticle.content;
    self.authorLabel.text = self.currentArticle.author;
    
    
    // video first solution
    NSString *fullURL = self.currentArticle.videoUrl;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.videoWebView loadRequest:requestObj];
    
//    // video second solution
//    // works only for youtube
//    // HTML to embed YouTube video
//    NSString *youTubeVideoHTML = @"<html><head>\
//    <body style=\"margin:0\">\
//    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//    width=\"%0.0f\" height=\"%0.0f\"></embed>\
//    </body></html>";
//    
//    // Populate HTML with the URL and requested frame size
//    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.currentArticle.videoUrl, self.videoWebView.frame.size.width, self.videoWebView.frame.size.height];
//    
//    // Load the html into the webview
//    [self.videoWebView loadHTMLString:html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArticleToShow:(NewsObject *)articleToShow {
    self.currentArticle = articleToShow;
}

//-(void) generateVideo: (NSString *) videoURL {
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:@"http://vbox7.com/play:b530b4ac6b"]];
//    player.view.frame = CGRectMake(20, 80, 350, 200);
//    [self.view addSubview:player.view];
//    [player play];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
