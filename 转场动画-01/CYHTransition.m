//
//  CYHTransition.m
//  转场动画-01
//
//  Created by 陈永辉 on 16/11/24.
//  Copyright © 2016年 Chenyonghui. All rights reserved.
//

#import "CYHTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"
@interface CYHTransition () <CAAnimationDelegate>
@property (nonatomic,weak)id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIBezierPath *maskFinalBP;
@property (nonatomic, strong) UIBezierPath *maskStartBP;
@property (nonatomic) UIViewController *fromVC;
@property (nonatomic) UIViewController *toVC;

@end

@implementation CYHTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

/*
 
 tansitionContextd的属性方法
 1、- (UIView *)containerView;
 //转场动画发生的容器
 2、- (UIViewController *)viewControllerForKey:(NSString *)key;
 // 我们可以通过它拿到过渡的两个 ViewController。
 3、   - (CGRect)initialFrameForViewController:(UIViewController *)vc;
 - (CGRect)finalFrameForViewController:(UIViewController *)vc;
 //通过这两个方法，可以获得过度动画前后两个ViewController的frame。
 */

//实现自定义的转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == Pop) {
        self.transitionContext = transitionContext;
        ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        SecondViewController *toVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        //获取容器
        UIView *contView = [transitionContext containerView];
        
        UIButton *button = fromVC.button;
        //创建椭圆形的贝塞尔曲线
        UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:button.frame];
        [contView addSubview:fromVC.view];
        [contView addSubview:toVC.view];
        
        //创建两个贝塞尔曲线一个:UIButton的size, 另外一个则拥有足够覆盖屏幕的半径 最终动画就是在这两个贝塞尔曲线之间进行
        CGPoint finalPoint;
        //判断触发点在那个象限
        if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
            if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
                //第一象限
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                //第四象限
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
            }
        }else{
            if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
                //第二象限
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                //第三象限
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
            }
        }
        CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
        UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
        //创建一个 CAShaperLayer 来负责圆形遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        //    maskLayer.path = maskFinalBP.CGPath; //指定为最终的 path 来避免动画完成后会回弹
        toVC.view.layer.mask = maskLayer;
        
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.fromValue = (__bridge id _Nullable)(maskStartBP.CGPath);
        maskLayerAnimation.toValue = (__bridge id _Nullable)(maskFinalBP.CGPath);
        maskLayerAnimation.duration = [self transitionDuration:transitionContext];
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        maskLayerAnimation.fillMode = kCAFillModeForwards;
        maskLayerAnimation.removedOnCompletion= NO;
        maskLayerAnimation.delegate = self;
        
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

    }else if (self.type == Push) {
        self.transitionContext = transitionContext;
        
        SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        ViewController *toVC   = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        UIButton *button = toVC.button;
        
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
        
        
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
        
        CGPoint finalPoint;
        
        //判断触发点在那个象限
        if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
            if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
                //第一象限
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                //第四象限
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
            }
        }else{
            if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
                //第二象限
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                //第三象限
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
            }
        }
        CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = finalPath.CGPath;
        fromVC.view.layer.mask = maskLayer;
        
        
        CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
        pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
        pingAnimation.duration = [self transitionDuration:transitionContext];
        pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        pingAnimation.delegate = self;
        
        [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];

    }
}




- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //告诉系统这这个 transition 完成
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    //清除View上的Mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}



@end
