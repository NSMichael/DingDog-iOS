//
//  TimeLineTextCell.m
//  ZhaoBu
//
//  Created by 耿功发 on 16/9/19.
//  Copyright © 2016年 9tong. All rights reserved.
//

#import "TimeLineTextCell.h"

NSString * const TimeLineTextCellIdentifier = @"TimeLineTextCellIdentifier";

@implementation TimeLineTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_textView) {
            _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 7, kScreen_Width-15*2, [TimeLineTextCell cellHeight]-10)];
            _textView.backgroundColor = [UIColor clearColor];
            _textView.font = kFont15;
            _textView.delegate = self;
            _textView.placeholder = @"请输入内容";
            _textView.placeholderColor = [UIColor lightGrayColor];
            _textView.returnKeyType = UIReturnKeyDefault;
            [self.contentView addSubview:_textView];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight{
    CGFloat cellHeight;
    if (kDevice_Is_iPhone5){
        cellHeight = 120;
    }else if (kDevice_Is_iPhone6) {
        cellHeight = 120;
    }else if (kDevice_Is_iPhone6Plus){
        cellHeight = 120;
    }else{
        cellHeight = 65;
    }
    return cellHeight;
}
- (BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    [self.textView becomeFirstResponder];
    return YES;
}

#pragma mark TextView Delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (self.textValueChangedBlock) {
        
        NSString *text = textView.text;
        if (text.length > 150) {
            text = [textView.text substringToIndex:150];
        }
        self.textValueChangedBlock(text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

@end
