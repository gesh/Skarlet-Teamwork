//
//  ArticleUITableViewCell.h
//  ITNews
//
//  Created by admin on 11/5/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbLabel;

@end
