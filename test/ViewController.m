//
//  ViewController.m
//  test
//
//  Created by Gaurav on 02/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "FMDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self callPostMethod];
}

-(void)callGetMethod {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://apidev.accuweather.com/currentconditions/v1/202438.json?language=en&apikey=hoArfRosT1215"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", responseObject);
            NSArray *arrayCategories = (NSArray*)responseObject;
            NSDictionary *dic = [arrayCategories objectAtIndex:0];
            NSLog(@"%@",dic);
            
            NSDictionary *tempDic = [dic objectForKey:@"Temperature"];
            NSLog(@"%@",tempDic);
            
            NSDictionary *metic = [tempDic objectForKey:@"Metric"];
            NSLog(@"value =%@",[metic objectForKey:@"Value"]);
            
        }
    }];
    [dataTask resume];

}

-(void)callPostMethod {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    
    NSString *URLString = @"http://date.jsontest.com/";
    NSDictionary *parameters = nil;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
  //  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", responseObject);
            
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MyDate.db"];
            FMDatabase *db = [FMDatabase databaseWithPath:path];
            
            if (![db open]) {
                // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
                db = nil;
                return;
            }
            
            
            
            
            
            
//            NSArray *arrayCategories = (NSArray*)responseObject;
//            NSDictionary *dic = [arrayCategories objectAtIndex:0];
//            NSLog(@"%@",dic);
//            
//            NSDictionary *tempDic = [dic objectForKey:@"Temperature"];
//            NSLog(@"%@",tempDic);
//            
//            NSDictionary *metic = [tempDic objectForKey:@"Metric"];
//            NSLog(@"value =%@",[metic objectForKey:@"Value"]);
            
        }
    }];
    [dataTask resume];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
