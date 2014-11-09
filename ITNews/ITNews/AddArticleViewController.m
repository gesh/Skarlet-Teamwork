//
//  AddArticleViewController.m
//  ITNews
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "AddArticleViewController.h"
#import <Parse/Parse.h>
#import "NewsObject.h"
#import "ConnectionInspector.h"

@interface AddArticleViewController ()

@end

@implementation AddArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)addArticleButton:(id)sender {
    [ConnectionInspector checkConnection];
    NSString* title = @"Error occurred!";
    NSString* messageContent = [self checkFields];
    
    if(messageContent == nil) {
        [self addArticle];
        
        title = @"Success!";
        messageContent = @"You have successfully added an article!";
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:messageContent
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
}

-(void) addArticle {
    PFObject *itNew = [PFObject objectWithClassName:@"News"];
    
    itNew[@"title"] = self.titleTextField.text;
    itNew[@"content"] = self.contentTextView.text;
    itNew[@"author"] = self.authorTextField.text;
    itNew[@"thumbUrl"] = self.thumbURLTextField.text;
    itNew[@"videoUrl"] = self.videoURLTextField.text;
    
    [itNew saveInBackground];
}

-(NSString*) checkFields {
    NSString* result = nil;
    
    if(self.titleTextField.text.length < 5) {
        result = @"Title should be at least 5 chars length!";
    } else if(self.contentTextView.text.length < 5) {
        result = @"Content should be at least 5 chars length!";
    } else if(self.authorTextField.text.length < 5) {
        result = @"Author name should be at least 5 chars length!";
    } else if(![[self.thumbURLTextField.text pathExtension] isEqualToString:@"jpg"] &&
              ![[self.thumbURLTextField.text pathExtension] isEqualToString:@"png"]) {
        result = @"Thumb URL should be a valid image URL!";
    } else {
        NSString *videoURLText = self.videoURLTextField.text;
        NSString *urlRegex = @"https://www.youtube.com/watch?v=";
        NSString *checkVideoURL = nil;
        
        if(videoURLText.length > urlRegex.length) {
            checkVideoURL = [videoURLText substringToIndex:urlRegex.length];
        }
        
        if(![checkVideoURL isEqualToString:urlRegex]) {
            result = @"Video URL should be a valid youtube video URL!";
        }
    }
    
    return result;
}

@end