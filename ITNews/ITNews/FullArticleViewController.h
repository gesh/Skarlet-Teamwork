//
//  FullArticleViewController.h
//  ITNews
//
//  Created by admin on 11/5/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObject.h"

@interface FullArticleViewController : UIViewController

@property (nonatomic,strong) NewsObject* currentArticle;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

-(void) setArticleToShow:(NewsObject *)articleToShow;
- (IBAction)addToFavorites:(id)sender;

@end
