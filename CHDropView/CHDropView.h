//
//  CHDropView.h
//  SYProject
//
//  Created by siyue on 15-3-19.
//  Copyright (c) 2015年 com.siyue.liuxn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDropModel.h"
@class CHDropTableView;

@interface CHDropView : UIView

@property (nonatomic,strong)NSArray *dropModelList;

@property (nonatomic,strong)void (^didSelect)(NSInteger,NSInteger);

- (void)showDropView;
- (void)hideDropView;
- (void)toggleDropView;

//可选参数
@property (nonatomic,assign)NSInteger defaultTopSelect; //默认选项
@property (nonatomic,assign)NSInteger defaultSecSelect;
@property (nonatomic,strong)UIColor *topBackGroundColor; //一级菜单背景颜色
@property (nonatomic,strong)UIColor *secBackGroundColor; //二级菜单背景颜色

@property (nonatomic)CGFloat transparentViewHeight; //底部透明部分高度
@property (nonatomic,strong)UIColor *bgColor; //底部透明部分颜色，当然也可以设置为不透明
@property (nonatomic)BOOL isAutoReSize; //是否根据内容调整dropView高度

@end
