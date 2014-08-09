//
//  GameViewController.m
//  Chase Z
//
//  Created by James Coughlan on 06/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//
    self.openglView = [[OpenGLView alloc]initWithFrame:screenBounds];
    [self.view addSubview:self.openglView];
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
