//
//  PGDatePickManager.m
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePickManager.h"
#import "PGDatePickManagerHeaderView.h"


@interface PGDatePickManager ()
@property (nonatomic, weak) UIView *contentView;
//@property (nonatomic, weak) PGDatePickManagerHeaderView *headerView;
@property (nonatomic, weak) UIView *dismissView;

@end

@implementation PGDatePickManager

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.customDismissAnimation = nil;
        [self setupDismissViewTapHandler];
        [self headerViewButtonHandler];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
//    self.dismissView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT);
//    self.contentView.backgroundColor = self.datePicker.backgroundColor;
//    [self.view bringSubviewToFront:self.contentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    self.headerView.language = self.datePicker.language;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.headerView.style = self.style;
    self.dismissView.frame = self.view.bounds;
    self.contentView.backgroundColor = self.datePicker.backgroundColor;
//    if (self.style == PGDatePickManagerStyleSheet) {
//        [self setupStyleSheet];
//    }else if (self.style == PGDatePickManagerStyleAlertTopButton) {
//        [self setupStyleAlert];
//    }else {
//        [self setupStyle3];
//    }
    [self.view bringSubviewToFront:self.contentView];
}

- (void)setupDismissViewTapHandler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewTapMonitor)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)headerViewButtonHandler {
    
    __weak typeof(self)weakSelf = self;
    
    self.headerView.finishBtnClickBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
        __strong PGDatePickManager *strong_self = weakSelf;
        
        NSArray *startArr = [startTime componentsSeparatedByString:@"-"];
        NSArray *endArr = [endTime componentsSeparatedByString:@"-"];
        
//        DDLogDebug(@"---startArr:%@---endArr:%@",startArr,endArr);
        //TODO:限制时间选择
        //如果结束时间比开始时间大3个月以上，提示不能查询
        
            //结束年份与开始年份是同一年
        if ([endArr[0] isEqualToString:startArr[0]]) {
            
            //结束月份 - 开始月份 >3 提示不能查询
            if ([endArr[1] integerValue] - [startArr[1] integerValue] > 3) {
                [MBProgressHUD showAutoHideMessage:@"当前仅支持查找3个自然月跨度的账单"];
                return ;
            }else if ([endArr[1] integerValue] - [startArr[1] integerValue] == 3){
                
                //结束月份 - 开始月份 =3
                //结束日期 > 开始日期 提示不能查询
                if (startArr.count >2 && [endArr[2] integerValue] > [startArr[2] integerValue]) {
                    [MBProgressHUD showAutoHideMessage:@"当前仅支持查找3个自然月跨度的账单"];
                    return;
                }
                
            }
        }else if ([endArr[0] integerValue] - [startArr[0] integerValue] > 1){
            
            //结束年份 - 开始年份 > 1 提示不能查询
             [MBProgressHUD showAutoHideMessage:@"当前仅支持查找3个自然月跨度的账单"];
            return;
        }else if ([endArr[0] integerValue] - [startArr[0] integerValue] == 1){
            //结束年份 - 开始年份 = 1
                //结束月份 + 12 - 开始月份 > 3 提示不能查询
            if ([endArr[1] integerValue] + 12 - [startArr[1] integerValue] > 3) {
                [MBProgressHUD showAutoHideMessage:@"当前仅支持查找3个自然月跨度的账单"];
                return;
            }else if ([endArr[1] integerValue] + 12 - [startArr[1] integerValue] == 3){
                //结束月份 + 12 - 开始月份 = 3 提示不能查询
                    //结束日期 > 开始日期 提示不能查询
                if (startArr.count >2 && [endArr[2] integerValue] > [startArr[2] integerValue]) {
                    [MBProgressHUD showAutoHideMessage:@"当前仅支持查找3个自然月跨度的账单"];
                    return;
                }
            }
            
        }
        
        if (strong_self.finishButtonMonitor) {
            strong_self.finishButtonMonitor(startTime, endTime);
        }
        
         [strong_self cancelButtonHandler];
        
        
    };
    
}

- (void)cancelButtonHandler {
    if (self.customDismissAnimation) {
        NSTimeInterval duration = self.customDismissAnimation(self.dismissView, self.contentView);
        if (duration && duration != NSNotFound) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:false completion:nil];
            });
        }
    } else {
        if (self.style == PGDatePickManagerStyleSheet) {
            CGRect contentViewFrame = self.contentView.frame;
            contentViewFrame.origin.y = self.view.bounds.size.height;
            [UIView animateWithDuration:0.2 animations:^{
                self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                self.contentView.frame = contentViewFrame;
            }completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:false completion:nil];
            }];
        }else {
            [self dismissViewControllerAnimated:false completion:nil];
        }
    }
}

- (void)dismissViewTapMonitor {
    [self cancelButtonHandler];
//    if (self.cancelButtonMonitor) {
//        self.cancelButtonMonitor();
//    }
}

- (void)setupStyleSheet {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewHeight = rowHeight * 4 + headerViewHeight;
    CGFloat datePickerHeight = contentViewHeight - headerViewHeight - bottom;
    CGRect contentViewFrame = CGRectMake(0,
                                         self.view.bounds.size.height - contentViewHeight,
                                         self.view.bounds.size.width,
                                         contentViewHeight);
    CGRect headerViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight);
    CGRect datePickerFrame = CGRectMake(0,
                                        CGRectGetMaxY(headerViewFrame),
                                        self.view.bounds.size.width,
                                        datePickerHeight);
    
    self.contentView.frame = CGRectMake(0,
                                        self.view.bounds.size.height,
                                        self.view.bounds.size.width,
                                        contentViewHeight);
    self.headerView.frame = headerViewFrame;
    self.datePicker.frame = datePickerFrame;
    self.headerView.backgroundColor = self.headerViewBackgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isShadeBackground) {
            self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        }
        self.contentView.frame = contentViewFrame;
        self.headerView.frame = headerViewFrame;
        self.datePicker.frame = datePickerFrame;
    }];
}

#pragma Setter

- (void)setIsShadeBackground:(BOOL)isShadeBackground {
    _isShadeBackground = isShadeBackground;
    if (isShadeBackground) {
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }else {
        self.dismissView.backgroundColor = [UIColor clearColor];
    }
    
    [self setupStyleSheet];
}

-(void)setDateComponents:(NSDateComponents *)dateComponents withStyle:(PGDatePickLabelStyle)labelStyle{
    
    _dateComponents = dateComponents;
    _labelStyle = labelStyle;
    
    self.headerView.dateComponents = dateComponents;
    self.headerView.style = labelStyle;
}

//- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
//    _cancelButtonFont = cancelButtonFont;
//    self.headerView.cancelButtonFont = cancelButtonFont;
//}
//
//- (void)setCancelButtonText:(NSString *)cancelButtonText {
//    _cancelButtonText = cancelButtonText;
//    self.headerView.cancelButtonText = cancelButtonText;
//}
//
//- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
//    _cancelButtonTextColor = cancelButtonTextColor;
//    self.headerView.cancelButtonTextColor = cancelButtonTextColor;
//}
//
//- (void)setConfirmButtonFont:(UIFont *)confirmButtonFont {
//    _confirmButtonFont = confirmButtonFont;
//    self.headerView.confirmButtonFont = confirmButtonFont;
//}
//
//- (void)setConfirmButtonText:(NSString *)confirmButtonText {
//    _confirmButtonText = confirmButtonText;
//    self.headerView.confirmButtonText = confirmButtonText;
//}
//
//- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor {
//    _confirmButtonTextColor = confirmButtonTextColor;
//    self.headerView.confirmButtonTextColor = confirmButtonTextColor;
//}

#pragma Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _contentView =view;
    }
    return _contentView;
}

- (PGDatePicker *)datePicker {
    if (!_datePicker) {
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:datePicker];
        _datePicker = datePicker;
    }
    return _datePicker;
}


- (PGDatePickerManagerCustomHeaderView *)headerView {
    if (!_headerView) {
        PGDatePickerManagerCustomHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"PGDatePickerManagerCustomHeaderView" owner:nil options:nil] lastObject];
        [self.contentView addSubview:view];
        _headerView = view;
    }
    return _headerView;
}

- (UIColor *)headerViewBackgroundColor {
    if (!_headerViewBackgroundColor) {
        _headerViewBackgroundColor = [UIColor whiteColor];
    }
    return _headerViewBackgroundColor;
}

- (CGFloat)headerHeight {
    if (!_headerHeight) {
        _headerHeight = 110;
    }
    return _headerHeight;
}

- (UIView *)dismissView {
    if (!_dismissView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _dismissView = view;
    }
    return _dismissView;
}

//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = self.headerView.titleLabel;
//    }
//    return _titleLabel;
//}

@end
