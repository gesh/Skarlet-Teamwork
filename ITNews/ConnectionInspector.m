//
//  ConnectionInspector.m
//  ITNews
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "ConnectionInspector.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>

@implementation ConnectionInspector 

+(void) checkConnection {
    
    Reachability *networkReachability;
    networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
       
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                                          message:@"There is no internet connection!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

@end
