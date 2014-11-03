//
//  NewsObject.h
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject

@property (nonatomic,strong) NSString* title;
@property (nonatomic, strong) NSString* author;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* videoUrl;
@property (nonatomic,strong) NSString* thumbUrl;

-(instancetype)initWithTitle: (NSString*) title
                   andAuthor: (NSString*) author
                  andContent: (NSString*) content
                 andVideoUrl: (NSString*) videoUrl
                 andThumbUrl: (NSString*) thumbUrl;


@end
