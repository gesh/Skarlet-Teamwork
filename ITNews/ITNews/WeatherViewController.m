//
//  WeatherControllerViewController.m
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "WeatherViewController.h"
#import "TALocationProvider.h"
#import "MBProgressHUD.h"
#import "ConnectionInspector.h"

@interface WeatherViewController ()<NSURLConnectionDelegate>

@end

@implementation WeatherViewController {
    NSString* url;
    NSString* dayOfWeek;
    NSString* weatherIconUrl;
    NSString* weatherInfo;
    NSString* fullCity;
    
    NSMutableData* responseData;
    
    TALocationProvider* locationProvider;
    MBProgressHUD *hud;
    
    double latitude;
    double longitude;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConnectionInspector checkConnection];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ConnectionInspector checkConnection];
    
    locationProvider = [[TALocationProvider alloc] init];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Loading.."];
    [self loadWeatherData];
    
    [locationProvider getLocationWithTarget:self
                                  andAction:@selector(locationUpdated:)];
    
}



-(void) loadWeatherData{
    url = [NSString stringWithFormat: @"http://api.wunderground.com/api/76d555a1a4146a4b/conditions/forecast/alert/q/%lf,%lf.json", latitude,longitude ];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [hud show:YES];
    [NSURLConnection connectionWithRequest:request delegate: self];
    
    
}

-(void) connection:(NSURLRequest*) request didReceiveData:(NSData *)data {
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if(json == nil){
        [self loadWeatherData];
    } else {
        NSDictionary* res = [json objectForKey: @"current_observation"];
    
        // full location
        NSDictionary* location = [res objectForKey:@"display_location"];
    
        // forecast info
        NSDictionary* forecast = [json objectForKey:@"forecast"];
        NSDictionary* txtForecast = [forecast objectForKey:@"txt_forecast"];
        NSArray* forecastDay = [txtForecast objectForKey:@"forecastday"];
        
        
        [hud hide:YES afterDelay: 0.5];
    
        // day of week
        dayOfWeek =[[forecastDay objectAtIndex:0] objectForKey:@"title"];
            if(dayOfWeek){
                CATransition *animation = [CATransition animation];
                animation.duration = 1.5;
                animation.type = kCATransitionFade;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.dayLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
                
                self.dayLabel.text = dayOfWeek;
            }
        
        // weather icon
        weatherIconUrl =[[forecastDay objectAtIndex:0] objectForKey:@"icon_url"];
            if(weatherIconUrl){
                NSURL *imageUrl = [NSURL URLWithString:weatherIconUrl];
                NSData *data = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *img = [[UIImage alloc] initWithData:data];
                
                CATransition *animation = [CATransition animation];
                animation.duration = 1.5;
                animation.type = kCATransitionFromLeft;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.weatherIconImageView.layer addAnimation:animation forKey:@"changeTextTransition"];
                
                [self.weatherIconImageView setImage: img];
            }
    
        // weather info
        weatherInfo =[[forecastDay objectAtIndex:0] objectForKey:@"fcttext_metric"];
            if(weatherInfo) {
                CATransition *animation = [CATransition animation];
                animation.duration = 1.5;
                animation.type = kCATransitionFromLeft;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.weatherInfoTextView.layer addAnimation:animation forKey:@"changeTextTransition"];
                self.weatherInfoTextView.text = weatherInfo;
            }
    
        // full location
        fullCity = [location objectForKey:@"full"];
            if(fullCity){
                CATransition *animation = [CATransition animation];
                animation.duration = 1.5;
                animation.type = kCATransitionFromLeft;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.cityLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
                self.cityLabel.text = fullCity;
            }
        
    }
    
}

-(void) locationUpdated: (CLLocation*) location{
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    [self loadWeatherData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {

    [locationProvider getLocationWithTarget:self
                                  andAction:@selector(locationUpdated:)];

}

// shake gesture
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Exit"
                              message:@"Do you want to exit?"
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        exit(0);
    }
}

@end
