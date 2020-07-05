//
//  ViewController.m
//  Test
//
//  Created by Gao on 2020/6/6.
//  Copyright © 2020 Gao. All rights reserved.
//

#import "ViewController.h"
#import "CustomViewController.h"
#import "Test-Swift.h"
#import <AFNetworking.h>

@interface ViewController ()

@property (nonatomic, strong) LKEventDatePickeView *pickerView;
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSMutableDictionary * cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"cookiename" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"cookieValue" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@".baidu.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:cookieProperties]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    
    [manager GET:@"http://218.75.123.182/index.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

@end
