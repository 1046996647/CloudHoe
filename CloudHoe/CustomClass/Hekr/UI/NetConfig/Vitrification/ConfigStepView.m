//
//  ConfigStepView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/1.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigStepView.h"
#import "Tool.h"
#import "ConfigSetpCell.h"

@interface ConfigStepView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) IBOutlet UITableView *table;
@property (nonatomic ,strong) NSMutableArray *steps;

@end

@implementation ConfigStepView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ConfigStepView" owner:self options:nil] objectAtIndex:0];
        UIView *view = [[UINib nibWithNibName:@"ConfigStepView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        view.frame = self.bounds;
        [self addSubview:view];
        
        [self setInitData];
        [self drawConfigStepView];
    }
    return self;
}

-(void)setInitData{
    //步骤有三种状态 0：失败，1：成功，2：进行中，3：未进行
    _steps = [NSMutableArray arrayWithArray:@[@(3),@(3),@(3),@(3),@(3)]];
    
}

-(void)drawConfigStepView{
    
    _table.bounces = NO;
    _table.backgroundColor = self.backgroundColor;
    _table.tableFooterView = [self footerView];
    [_table registerNib:[UINib nibWithNibName:@"ConfigSetpCell" bundle:nil] forCellReuseIdentifier:@"SetpIdentifier"];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(UIView *)footerView{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Hrange(40))];
    v.backgroundColor = self.backgroundColor;
    return v;
}

-(void)start{
    
    [_steps replaceObjectAtIndex:0 withObject:@(2)];
    [_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)configSuccessWithStep:(ConfigDeviceStep )setp{
    [self setConfigWithStep:setp state:YES];
}

-(void)configFailWithStep:(ConfigDeviceStep )setp{
    [self setConfigWithStep:setp state:NO];
}

-(void)setConfigWithStep:(NSInteger)setp state:(BOOL )state{
    if (state) {
        for (NSInteger index=0; index<_steps.count; index++) {
            if (index<=setp) {
                [_steps replaceObjectAtIndex:index withObject:@(1)];
            }else if (index==(setp+1)) {
                [_steps replaceObjectAtIndex:index withObject:@(2)];
            }
        }
    }else{
        for (NSInteger index=0; index<_steps.count; index++) {
            if (index<setp) {
                [_steps replaceObjectAtIndex:index withObject:@(1)];
            }else if (index==setp) {
                [_steps replaceObjectAtIndex:index withObject:@(0)];
            }
        }
    }
    [_table reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _steps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfigSetpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetpIdentifier" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"ConfigSetpCell" bundle:nil] instantiateWithOwner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setConfigStep:indexPath.row state:[[_steps objectAtIndex:indexPath.row] integerValue]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Hrange(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
