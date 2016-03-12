//
//  CHViewController.m
//  choutixiaoguo
//
//  Created by nick on 16/3/12.
//  Copyright © 2016年 nick. All rights reserved.
//

#import "CHViewController.h"
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define targetR 300
#define targetL -300
@interface CHViewController ()
@property (nonatomic, weak) UIView *mainV;
@property (nonatomic, weak) UIView *rightV;
@end

@implementation CHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控件
    [self SetUpView];
    
    //创建拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //添加手势
    [self.mainV addGestureRecognizer:pan];
    //创建点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

//实现拖动手势
- (void)pan:(UIPanGestureRecognizer *)pan{
    //获取当前点在屏幕上的偏移量
    CGPoint curP = [pan translationInView:self.mainV];
    //    self.mainV.transform = CGAffineTransformTranslate(self.mainV.transform, curP.x, curP.y);
    //获取frame
    self.mainV.frame = [self frameWithOffset:curP.x];
    if (self.mainV.frame.origin.x > 0) {
        self.rightV.hidden = YES;
    }else if (self.mainV.frame.origin.x <0){
        self.rightV.hidden = NO;
    }
    //停止拖动时
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat target = 0;
        if (self.mainV.frame.origin.x > screenW * 0.5) {
            target = targetR;
        }else if (CGRectGetMaxX(self.mainV.frame)< screenW * 0.5){
            target = targetL;
        }
        CGFloat offset = target - self.mainV.frame.origin.x;
        [UIView animateWithDuration:0.25 animations:^{
            self.mainV.frame = [self frameWithOffset:offset];
        }];
    }
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
}
//根据偏移量 改变frame值
- (CGRect)frameWithOffset:(CGFloat)offset{
    CGRect frame= self.mainV.frame;
    frame.origin.x += offset;
    //绝对值
    frame.origin.y = fabs(frame.origin.x * 150 /screenW);
    frame.size.height = screenH - (2 * frame.origin.y);
    return frame;
}
//实现点按手势
- (void)tap:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainV.frame = self.view.frame;
    }];
}

//添加控件
- (void)SetUpView{
    //左边View
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftV];
    
    //右边View
    UIView *rightV = [[UIView alloc] initWithFrame:self.view.bounds];
    rightV.backgroundColor = [UIColor blueColor];
    _rightV = rightV;
    [self.view addSubview:rightV];
    //中间View
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    _mainV = mainV;
    [self.view addSubview:mainV];
}
@end

