//
//  News.h
//  ITNews
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * thumbUrl;
@property (nonatomic, retain) NSString * videoUrl;

@end