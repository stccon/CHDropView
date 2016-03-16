//
//  ViewController.m
//  CHDropViewDemo
//
//  Created by lyy on 16/3/15.
//  Copyright © 2016年 hyc. All rights reserved.
//

#import "ViewController.h"
#import "CHDropView.h"

@interface ViewController ()

@property(nonatomic,strong)CHDropView *dropView;
- (IBAction)click:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dropView = [[CHDropView alloc] initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [self.view addSubview:self.dropView];
    
    NSMutableArray *dropArr = [[NSMutableArray alloc] init];
    NSArray *topArr = @[@"蜀国",@"魏国"];
    NSArray *secArr = @[@"刘备",@"关羽",@"张飞"];
    NSArray *secArr1 = @[@"曹操",@"司马懿",@"张辽"];
    NSArray *arr = @[secArr,secArr1];
    for (NSInteger i=0;i<topArr.count;i++) {
        NSString *str = topArr[i];
        CHDropModel *model = [[CHDropModel alloc] init];
        model.itemName = str;
        NSArray *subArrStr = arr[i];
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        for (NSString *subStr in subArrStr) {
            CHDropModel *subModel = [[CHDropModel alloc] init];
            subModel.itemName = subStr;
            [subArr addObject:subModel];
        }
        model.subDropList = subArr;
        [dropArr addObject:model];
    }
    self.dropView.dropModelList = dropArr;
    
    
    //CHDropModel *model
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    [self.dropView toggleDropView];
}
@end
