//
//  TALocationProvider.h
//  ITNews
//
//  Created by admin on 11/7/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TALocationProvider : NSObject

-(void) getLocationWithBlock: (void(^)(CLLocation* location)) block;

-(void) getLocationWithTarget:(id) target
                    andAction:(SEL) action;

@end
