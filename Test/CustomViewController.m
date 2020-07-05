//
//  CustomViewController.m
//  Test
//
//  Created by Gao on 2020/6/6.
//  Copyright © 2020 Gao. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation CustomViewController

-(void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    __weak typeof(self) weakSelf = self;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(test) userInfo:nil repeats:YES];
    
    NSLog(@"%@",self.timer);
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@",self.timer);
}

-(void)test {
    NSLog(@"asd");
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
