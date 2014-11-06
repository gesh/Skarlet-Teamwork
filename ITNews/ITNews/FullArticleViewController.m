//
//  FullArticleViewController.m
//  ITNews
//
//  Created by admin on 11/5/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "FullArticleViewController.h"

@interface FullArticleViewController () {
  
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (nonatomic,strong) NewsObject* currentArticle;

@end

@implementation FullArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.titleLabel.text = @"sadas";
    self.titleLabel.text = self.currentArticle.title;
    self.contentTextField.text = self.currentArticle.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArticleToShow:(NewsObject *)articleToShow {
    self.currentArticle = articleToShow;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
