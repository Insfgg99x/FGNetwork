//
//  ViewController.m
//  FGNetworkD emo
//
//  Created by 夏桂峰 on 16/9/13.
//  Copyright © 2016年 夏桂峰. All rights reserved.
//

#import "ViewController.h"
#import "FGNetwork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadData];
}

-(void)downloadData{
    
    [[FGNetwork shared] get:@"http://www.baidu.com" success:^(NSData *data, NSURLResponse *response) {
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
    } failure:^(NSError *error) {
        
    }];
}

@end
