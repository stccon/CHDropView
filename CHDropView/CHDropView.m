//
//  CHDropView.m
//  SYProject
//
//  Created by siyue on 15-3-19.
//  Copyright (c) 2015年 com.siyue.liuxn. All rights reserved.
//

#import "CHDropView.h"
#import "CHDropTableView.h"

@interface CHDropView()
@property (strong,nonatomic) NSMutableArray *dropTableViewList;
@property (strong,nonatomic) CHDropTableView *topDropTableView;
@property (strong,nonatomic) CHDropTableView *secDropTableView;

@property (assign,nonatomic) NSInteger topSelect;
@property (assign,nonatomic) NSInteger secSelect;
@property (nonatomic,assign)CGRect topDropTableViewFrame;
@property (nonatomic,assign)CGRect secDropTableViewFrame;

#define CH_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CH_HEIGHT [[UIScreen mainScreen] bounds].size.height

@end

@implementation CHDropView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        //默认数据
        self.defaultTopSelect = 0;
        self.defaultSecSelect = -1;
        self.topSelect = self.defaultTopSelect;//－1表示未选择或不存在选项
        self.secSelect = self.defaultSecSelect;
        self.bgColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        self.transparentViewHeight = 64;
        self.isAutoReSize = NO;
        
        UIView *bottomBGView = [[UIView alloc] initWithFrame:self.bounds];
        bottomBGView.backgroundColor = self.bgColor;
        [self addSubview:bottomBGView];

        self.backgroundColor = self.bgColor;

        
        //默认下拉菜单的frame
        self.topDropTableViewFrame = CGRectMake(0, 0, frame.size.width/2, frame.size.height-self.transparentViewHeight);
        self.secDropTableViewFrame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height-self.transparentViewHeight);
        
        //初始化下拉菜单
        self.topDropTableView = [[CHDropTableView alloc] initWithFrame:self.topDropTableViewFrame];
        self.secDropTableView = [[CHDropTableView alloc] initWithFrame:self.secDropTableViewFrame];
        [self addSubview:self.topDropTableView];
        [self addSubview:self.secDropTableView];
        self.topDropTableView.tableColor = [UIColor whiteColor];
        self.topDropTableView.cellColor = [UIColor whiteColor];
        self.secDropTableView.cellColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
        self.secDropTableView.tableColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
        self.topDropTableView.tableFooterView = [UIView new];
        self.secDropTableView.tableFooterView = [UIView new];
        //self.topDropTableView.backgroundColor = [UIColor clearColor];
        
        //一级
        __block CHDropView *blockSelf = self;
        self.topDropTableView.didSelect = ^(NSInteger topRow) {
            blockSelf.topSelect = topRow;
            CHDropModel *topDropModel = blockSelf.dropModelList[topRow];
            if (topDropModel.subDropList.count==0) {
                blockSelf.hidden = YES;
                blockSelf.secSelect = -1;
                if (blockSelf.didSelect!=nil) {
                    blockSelf.didSelect(blockSelf.topSelect,blockSelf.secSelect);
                }
            }
            else {
                if (blockSelf.secDropTableView.hidden) {
                    //[blockSelf addAnimationForView:blockSelf.secDropTableView withType:@"push" withSubType:@"fromRight" withDuration:0.2];
                }
                blockSelf.secDropTableView.hidden = NO;
                NSMutableArray *secItemNameS = [[NSMutableArray alloc] initWithCapacity:topDropModel.subDropList.count];
                for (CHDropModel *secDropModel in topDropModel.subDropList) {
                    NSString *secItemName = secDropModel.itemName;
                    [secItemNameS addObject:secItemName];
                }
                blockSelf.secDropTableView.items = secItemNameS;
            }
        };
        
        //二级
        self.secDropTableView.didSelect = ^(NSInteger secRow) {
            blockSelf.secSelect = secRow;
            blockSelf.hidden = YES;
            if (blockSelf.didSelect!=nil) {
                blockSelf.didSelect(blockSelf.topSelect,blockSelf.secSelect);
            }
        };
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*if (self.didSelect!=nil) {
        self.didSelect();
    }*/
    self.hidden = YES;
}

#pragma mark - 成员变量

- (void)setTopDropTableViewFrame:(CGRect)topDropTableViewFrame
{
    _topDropTableViewFrame = topDropTableViewFrame;
    self.topDropTableView.frame = _topDropTableViewFrame;
}

- (void)setSecDropTableViewFrame:(CGRect)secDropTableViewFrame
{
    _secDropTableViewFrame = secDropTableViewFrame;
    self.secDropTableView.frame = _secDropTableViewFrame;
}

- (void)setDropModelList:(NSArray *)dropModelList
{
    _dropModelList = dropModelList;
    NSMutableArray *topItemNameS = [[NSMutableArray alloc] initWithCapacity:dropModelList.count];
    NSMutableArray *subItemNumS = [[NSMutableArray alloc] initWithCapacity:dropModelList.count];
    BOOL isOneLevel = YES;//是否只有一级
    for (CHDropModel *dropModel in _dropModelList) {
        NSString *topItemName = dropModel.itemName;
        [topItemNameS addObject:topItemName];
        NSString *subItemNum = [NSString stringWithFormat:@"%lu",(unsigned long)dropModel.subDropList.count];
        [subItemNumS addObject:subItemNum];
        if (dropModel.subDropList.count>0) {//两级
            isOneLevel = NO;
        }
    }
    self.topDropTableView.items = topItemNameS;
    self.topDropTableView.subItemNums = subItemNumS;
    if (isOneLevel) {
        CGRect frame = self.topDropTableViewFrame;
        frame.size.width = self.frame.size.width;
        self.topDropTableViewFrame = frame;
    }else {
        CGRect frame = self.topDropTableViewFrame;
        frame.size.width = self.frame.size.width/2;
        self.topDropTableViewFrame = frame;
    }
    
    [self.superview bringSubviewToFront:self];
    
}

- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        //[self addAnimationForView:self withType:@"push" withSubType:@"fromLeft" withDuration:0.3];
    }
    else {
        //[self addAnimationForView:self withType:@"push" withSubType:@"fromRight" withDuration:0.3];
    }
    [super setHidden:hidden];
    CHDropModel *topDropModel = self.dropModelList[self.topSelect];
    if (topDropModel.subDropList.count==0) {
        self.secDropTableView.hidden = YES;
    }
    else {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.topSelect inSection:0];
        [self.topDropTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        NSMutableArray *secItemNameS = [[NSMutableArray alloc] initWithCapacity:topDropModel.subDropList.count];
        for (CHDropModel *secDropModel in topDropModel.subDropList) {
            NSString *secItemName = secDropModel.itemName;
            [secItemNameS addObject:secItemName];
        }
        self.secDropTableView.items = secItemNameS;
        
        //调整tableView高度，去掉table底部多余的地方
        if (self.isAutoReSize) {
            if (self.secDropTableView.contentSize.height<self.secDropTableView.frame.size.height) {
                CGRect frame = self.secDropTableView.frame;
                frame.size.height = self.secDropTableView.contentSize.height;
                self.secDropTableView.frame = frame;
            }
        }
        
        self.secDropTableView.hidden = NO;
    }
    
    //默认选择某一项
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.topSelect inSection:0];
    [self.topDropTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //调整tableView高度，去掉table底部多余的地方
    if (self.isAutoReSize) {
        if (self.topDropTableView.contentSize.height<self.topDropTableView.frame.size.height) {
            CGRect frame = self.topDropTableView.frame;
            frame.size.height = self.topDropTableView.contentSize.height;
            self.topDropTableView.frame = frame;
        }
    }
}

- (void)setTopBackGroundColor:(UIColor *)topBackGroundColor
{
    _topBackGroundColor = topBackGroundColor;
    self.topDropTableView.tableColor = _topBackGroundColor;
    self.topDropTableView.cellColor = _topBackGroundColor;
}

- (void)setSecBackGroundColor:(UIColor *)secBackGroundColor
{
    _secBackGroundColor = secBackGroundColor;
    self.secDropTableView.tableColor = _secBackGroundColor;
    self.secDropTableView.cellColor = _secBackGroundColor;
}

- (void)setDefaultTopSelect:(NSInteger)defaultTopSelect
{
    _defaultSecSelect = defaultTopSelect;
    self.topSelect = _defaultSecSelect;
}


//动画
- (void)addAnimationForView:(UIView *)view withType:(NSString *)type withSubType:(NSString *)subType withDuration:(CFTimeInterval)time
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:time];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setType:type];
    [animation setSubtype: subType];
    [view.layer addAnimation:animation forKey:@"Reveal"];
}

- (void)showDropView{
    self.hidden = NO;
}

- (void)hideDropView{
    self.hidden = YES;
}

- (void)toggleDropView{
    self.hidden = !self.hidden;
}

@end
