//
//  WeatherControllerViewController.m
//  ITNews
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()<NSURLConnectionDelegate>

@end

@implementation WeatherViewController {
    NSString* url;
    NSString* dayOfWeek;
    NSString* weatherIconUrl;
    NSString* weatherInfo;
    NSString* fullCity;
    
    NSMutableData* responseData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"Weather controller loaded");
    [self loadData];
    
    
}


-(void) loadData{
    url = @"http://api.wunderground.com/api/7904905845b78b09/conditions/forecast/alert/q/17.382042000000000000,78.48172729999999000.json";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection connectionWithRequest:request delegate: self];
}

-(void) connection:(NSURLRequest*) request didReceiveData:(NSData *)data {

  
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(json == nil){
            NSLog(@"json is nil");
            [self loadData];
        } else {
    
        
    NSDictionary* res = [json objectForKey: @"current_observation"];
    
    // full location
    NSDictionary* location = [res objectForKey:@"display_location"];
    
    // forecast info
    NSDictionary* forecast = [json objectForKey:@"forecast"];
    NSDictionary* txtForecast = [forecast objectForKey:@"txt_forecast"];
    NSArray* forecastDay = [txtForecast objectForKey:@"forecastday"];
    
    // day of week
    dayOfWeek =[[forecastDay objectAtIndex:0] objectForKey:@"title"];
    NSLog(@"Day: %@",dayOfWeek);
    
    // weather icon
    weatherIconUrl =[[forecastDay objectAtIndex:0] objectForKey:@"icon_url"];
    NSLog(@"Icon: %@",weatherIconUrl);
    
    // weather info
    weatherInfo =[[forecastDay objectAtIndex:0] objectForKey:@"fcttext_metric"];
    NSLog(@"Weather: %@",weatherInfo);
    
    // full location
    fullCity = [location objectForKey:@"full"];
    NSLog(@"%@",fullCity);
    }
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
