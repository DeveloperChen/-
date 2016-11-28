//
//  CYHTransition.h
//  转场动画-01
//
//  Created by 陈永辉 on 16/11/24.
//  Copyright © 2016年 Chenyonghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersentType){
    Push,
    Pop
};

@interface CYHTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PersentType type;

@end
