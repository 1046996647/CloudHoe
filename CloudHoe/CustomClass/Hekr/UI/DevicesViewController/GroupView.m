//
//  GroupView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "GroupView.h"
#import "HomeDevicesLayout.h"
#import "DevCell.h"
#import "EasyMacro.h"
#import "AudioToolbox/AudioToolbox.h"
#import "Tool.h"
//#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Hrange(x)  (x/750.0)*ScreenWidth
//#define Vrange(x)  (x/1334.0)*ScreenHeight
//#define MAX_STARWORDS_LENGTH 16
@interface GroupView ()<MergeAbleDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DevDelete>
@property (nonatomic, strong)HekrFold *g;
@property (nonatomic, strong)HekrFold *group;
@property (nonatomic, strong)UIView *groupview;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic ,strong) NSArray *lanDevices;

@end

@implementation GroupView

- (instancetype)initWithFrame:(CGRect)frame Data:(HekrFold *)data GroupModel:(GroupModel *)groupmodel lanDevices:(NSArray *)lanDevices{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = frame;
        _g = data;
        _groupmodel = groupmodel;
        _isReload = YES;
        self.lanDevices = lanDevices;
        [self createViews];
    }
    return self;
}
-(void) didMergeItem:(NSIndexPath*) index withItem:(NSIndexPath*) toIndex block:(void(^)(NSDictionary* ))block{
    [(GroupModel*)_groupmodel moveOutDevceAt:index.item block:block];
}
- (BOOL) canMergeItem:(NSIndexPath *)index withItem:(NSIndexPath *)toIndex{
    return [self isOutBondIndex:toIndex];
}
- (BOOL) isOutBondIndex:(NSIndexPath*) index{
    return (index.item == -1 && index.section == -1);
}
- (BOOL) canMergeItem:(NSIndexPath *)index{
    if (!index) {
        return NO;
    }else{
        return [self isDevice:[_groupmodel.datas objectAtIndex:index.item]];
    }
}
- (BOOL) isDevice:(id) item{
    return [item isKindOfClass:[HekrDevice class]];
}
- (void)didSelectDeleteAction:(NSIndexPath *)idx{
    [self.delegate groupdidSelectDeleteAction:idx];
}

- (BOOL)isGroup{
    return YES;
}

-(UIView*) contentView{
    return self;
}

- (void)createViews{

    
    //            [_mainview addGestureRecognizer:tgr];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainOut:)];
    UIView *mainBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mainBgView.backgroundColor = [UIColor blackColor];
    mainBgView.alpha = 0.6;
    [mainBgView addGestureRecognizer:tgr];
    [self addSubview:mainBgView];
    _groupview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-Hrange(40), ScreenWidth-Hrange(40)+Vrange(150))];
    
    _groupview.center = CGPointMake(ScreenWidth/2, ScreenHeight/2-Vrange(100));
    _groupview.layer.cornerRadius = 24;
    _groupview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *groupBgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, Vrange(150), _groupview.frame.size.width, _groupview.frame.size.width)];
    groupBgImg.contentMode = UIViewContentModeScaleAspectFill;
    groupBgImg.clipsToBounds = YES;
    groupBgImg.image = [UIImage imageNamed:getDeviseViewBgImg()];
    groupBgImg.userInteractionEnabled = YES;
    //            groupBgImg.contentMode = UIViewContentModeCenter;
    [_groupview addSubview:groupBgImg];
    
    _groupname = [[UITextField alloc]initWithFrame:CGRectMake(0, Vrange(40), _groupview.frame.size.width, Vrange(150)-Vrange(80))];
    _groupname.textAlignment = NSTextAlignmentCenter;
    _groupname.backgroundColor = [UIColor clearColor];
    _groupname.font = [UIFont systemFontOfSize:Vrange(50)];
    _groupname.text = _g.name;
    _groupname.delegate = self;
    _groupname.returnKeyType=UIReturnKeyDone;
    _groupname.tag=200;
    [_groupname addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _group = _g;
    
    _groupcollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Vrange(150), _groupview.frame.size.width, _groupview.frame.size.width) collectionViewLayout:[HomeDevicesLayout new]];
    _groupcollection.delegate = self;
    _groupcollection.dataSource = self;
    _groupcollection.tag = 1001;
    //            _groupcollection.layer.masksToBounds = YES;
    //            _groupcollection.clipsToBounds = NO;
    _groupcollection.backgroundColor = [UIColor clearColor];
    [_groupcollection registerClass:[DevCell class] forCellWithReuseIdentifier:@"GCell"];
    [_groupcollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WCell"];
    [_groupview addSubview:_groupcollection];
    [_groupview addSubview:_groupname];
    [self addSubview:_groupview];
    
}

- (void)mainOut:(UITapGestureRecognizer *)tgr{
    [self.delegate groupMainOut:tgr];
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        if (textField.tag==200) {
            [_groupmodel rename:_groupname.text blok:^(BOOL isSuccess) {
                if (isSuccess == NO) {
                    [self.delegate groupRenameFail];
                    textField.text = _groupName;
                }else{
                    [textField resignFirstResponder];
                }
            }];
//            [self endEditing:YES];

        }
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (string) {
        NSString *regex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if(![pred evaluateWithObject: string])
        {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)vibrationAction{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)LongPressGestureAnimate{
    _isCellAnimate = NO;
}

- (BOOL)isReload{
    return _isCellAnimate;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _groupName = textField.text;
}



- (void)TextDidChange:(UITextField *)textfield
{
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    //    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!selectedRange)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - UIcollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _groupmodel.datas.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id data = [_groupmodel.datas objectAtIndex:indexPath.item];
    if ([data isKindOfClass:[HekrPlacehode class]]) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"WCell" forIndexPath:indexPath];
    }
    DevCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.layer.masksToBounds = YES;
    cell.devDelete.hidden = _isReload;
    cell.backgroundColor = [UIColor clearColor];
    cell.hekrGroup.hidden = YES;
    if (_isReload) {
        cell.img.alpha = 1.0;
        cell.name.alpha = 1.0;
        cell.imgBgView.alpha = 1.0;
        
    }else{
        cell.img.alpha = 0.5;
        cell.name.alpha = 0.5;
        cell.imgBgView.alpha = 0.5;
    }
    [cell update:data isHekrGroup:NO GroupName:nil lanDevices:self.lanDevices];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id dev = [_groupmodel.datas objectAtIndex:indexPath.item];
    if ([dev isKindOfClass:[HekrPlacehode class]])
    {
        return;
    }
    
    HekrDevice *sdev = dev;
//    if (sdev.online == YES) {
        [self.delegate groupStaViewMove];
//        [_staView removeFromSuperview];
       [self.delegate groupJumpTo:[NSURL URLWithString:controlURLForDevice(sdev)] devData:sdev.props];
//        [self jumpTo:[NSURL URLWithString:controlURLForDevice(sdev)]];
        NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
//    }else{
//        [self.delegate groupAlertView];
//        
//    }

}

- (void)deleteDev:(UIButton *)sender{
    [self.delegate groupDelets:sender];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
