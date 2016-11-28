//
//  ViewController.m
//  转场动画-01
//
//  Created by 陈永辉 on 16/11/24.
//  Copyright © 2016年 Chenyonghui. All rights reserved.
//

#import "ViewController.h"
#import "CYHTransition.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.button.layer.cornerRadius = 30;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        CYHTransition *ping = [CYHTransition new];
        ping.type = Pop;
        return ping;
    }else{
        return nil;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
