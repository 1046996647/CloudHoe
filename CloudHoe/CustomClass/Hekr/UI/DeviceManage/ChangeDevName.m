//
//  ChangeDevName.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ChangeDevName.h"
#import "Tool.h"

#define COLOR_BLUE rgb(79, 155, 255)

@interface ChangeDevName ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;


@end

@implementation ChangeDevName

- (void)awakeFromNib{
    [super awakeFromNib];
    _mainView.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabel.text = NSLocalizedString(@"修改设备名称", nil);
    _textFiled.placeholder = NSLocalizedString(@"请输入设备名称", nil);
    _textFiled.delegate = self;
    [_textFiled addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textFiled becomeFirstResponder];
    [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [_changeButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_cancelButton setTitleColor:rgb(79, 155, 255) forState:UIControlStateNormal];
    [_changeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _changeButton.userInteractionEnabled = NO;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)TextDidChange:(UITextField *)textfield
{
    NSString *toBeString = textfield.text;
    if (toBeString.length <= 0) {
        [_changeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _changeButton.userInteractionEnabled = NO;
    }else{
        [_changeButton setTitleColor:rgb(79, 155, 255) forState:UIControlStateNormal];
        _changeButton.userInteractionEnabled = YES;
    }
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


- (IBAction)cacelAction:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)changeAction:(UIButton *)sender {
    [self removeFromSuperview];
    [self.delegeate changeDevName:_textFiled.text];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
