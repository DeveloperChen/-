//
//  SecondViewController.m
//  转场动画-01
//
//  Created by 陈永辉 on 16/11/24.
//  Copyright © 2016年 Chenyonghui. All rights reserved.
//

#import "SecondViewController.h"
#import "CYHTransition.h"
@interface SecondViewController () <UINavigationControllerDelegate>

@end

@implementation SecondViewController {
    UIPercentDrivenInteractiveTransition *percentTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backButton.layer.cornerRadius = 30;
    
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
    
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        CYHTransition *pingInvert = [CYHTransition new];
        pingInvert.type = Push;
        return pingInvert;
    }else{
        return nil;
    }
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
