//
//  NewsObject.m
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "NewsObject.h"

@implementation NewsObject

-(instancetype)initWithTitle: (NSString*) title
                   andAuthor: (NSString*) author
                  andContent: (NSString*) content
                 andVideoUrl: (NSString*) videoUrl
                 andThumbUrl: (NSString*) thumbUrl {
    
    if(self = [super init]) {
        
        self.title = title;
        self.author = author;
        self.content = content;
        self.videoUrl = videoUrl;
        self.thumbUrl = thumbUrl;
    }
    
    return  self;
}

@end
