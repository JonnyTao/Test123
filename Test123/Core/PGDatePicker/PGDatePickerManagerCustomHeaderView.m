//
//  PGDatePickerManagerCustomHeaderView.m
//  Demo
//
//  Created by Super Mac on 2019/11/25.
//  Copyright © 2019 piggybear. All rights reserved.
//

#import "PGDatePickerManagerCustomHeaderView.h"
#import "UIColor+PGHex.h"

@interface PGDatePickerManagerCustomHeaderView ()
@property (nonatomic,weak) IBOutlet UIButton *chooseBtn;

@property (nonatomic,weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic,weak) IBOutlet UIView *startDateLine;

@property (nonatomic,weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic,weak) IBOutlet UIView *endDateLine;

@end

@implementation PGDatePickerManagerCustomHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
//    [self setupNormalUI:self.startDateLabel andLine:self.startDateLine];
    [self.startDateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startDateLabelClick)]];
    
//    [self setupNormalUI:self.endDateLabel andLine:self.endDateLine];
    [self.endDateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endDateLabelClick)]];
}

#pragma mark action

- (IBAction)finishBtnDidClick:(id)sender {
    
    NSLog(@"------finishBtnDidClick");
    if (self.finishBtnClickBlock) {
        self.finishBtnClickBlock(self.startDateLabel.text,self.endDateLabel.text);
    }
}

- (IBAction)chooseBtnDidClick:(id)sender {
    
    self.pickerModel = (self.pickerModel == PGDatePickerModeYearAndMonth) ? PGDatePickerModeDate:PGDatePickerModeYearAndMonth;
    
    [self.chooseBtn setTitle:(self.pickerModel == PGDatePickerModeYearAndMonth) ? @"按月选择" :@"按日选择" forState:UIControlStateNormal];
    
    [self startDateLabelClick];
    [self setupNormalUI:self.startDateLabel andLine:self.startDateLine];
    [self setupNormalUI:self.endDateLabel andLine:self.endDateLine];
    
    NSLog(@"------chooseBtnDidClick");
    if (self.chooseBtnClickBlock) {
        self.chooseBtnClickBlock(self.pickerModel);
    }
}

-(void)startDateLabelClick{
    NSLog(@"------startDateLabelClick");
    
    if (self.labelClickBlock) {
        self.labelClickBlock(PGDatePickLabelStyleStart,self.endDateLabel.text);
    }
}

-(void)endDateLabelClick{
    NSLog(@"------endDateLabelClick");
    
    if (self.labelClickBlock) {
        self.labelClickBlock(PGDatePickLabelStyleEnd,self.startDateLabel.text);
    }
}


#pragma mark setter

-(void)setPickerModel:(PGDatePickerMode)pickerModel{
    
    _pickerModel = pickerModel;
    
    [self.chooseBtn setTitle:(pickerModel == PGDatePickerModeYearAndMonth) ? @"按月选择" :@"按日选择" forState:UIControlStateNormal];
    [self setupNormalUI:self.startDateLabel andLine:self.startDateLine];
    [self setupNormalUI:self.endDateLabel andLine:self.endDateLine];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents{
    
    _dateComponents = dateComponents;
}

-(void)setStyle:(PGDatePickLabelStyle)style{
    _style = style;
    
    if (style == PGDatePickLabelStyleStart) {

        NSString *str;
        if (_pickerModel == PGDatePickerModeYearAndMonth) {
            str = [NSString stringWithFormat:@"%ld-%02ld",self.dateComponents.year,self.dateComponents.month];
        }else if (_pickerModel == PGDatePickerModeDate){
            str = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.dateComponents.year,self.dateComponents.month,self.dateComponents.day];
        }
        [self setupSelectUI:self.startDateLabel andLine:self.startDateLine andDateString:str];

    }
    else if (style == PGDatePickLabelStyleEnd){

        NSString *str;
        if (self.pickerModel == PGDatePickerModeYearAndMonth) {
            str = [NSString stringWithFormat:@"%ld-%02ld",self.dateComponents.year,self.dateComponents.month];
        }else if (self.pickerModel == PGDatePickerModeDate){
            str = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.dateComponents.year,self.dateComponents.month,self.dateComponents.day];
        }
        [self setupSelectUI:self.endDateLabel andLine:self.endDateLine andDateString:str];
    }
}

#pragma mark  private
-(void)setupNormalUI:(UILabel *)label andLine:(UIView *)view{
    
    switch (label.tag) {
        case 666:
        {
            if (self.pickerModel == PGDatePickerModeYearAndMonth) {
                label.text = @"开始月份";
            }else{
                label.text = @"开始日期";
            }
        }
            break;
        case 667:
        {
            if (self.pickerModel == PGDatePickerModeYearAndMonth) {
                label.text = @"结束月份";
            }else{
                label.text = @"结束日期";
            }
//            label.text = @"结束时间";
        }
            break;
            
        default:
            break;
    }
    
    label.textColor = [UIColor pg_colorWithHexString:@"#818181"];
    view.backgroundColor = [UIColor pg_colorWithHexString:@"#EAEAEA"];
}

-(void)setupSelectUI:(UILabel *)label andLine:(UIView *)view andDateString:(NSString *)dateStr{
    
    label.text = dateStr;
    label.textColor = [UIColor pg_colorWithHexString:@"#5E60C7"];
    view.backgroundColor = [UIColor pg_colorWithHexString:@"#5E60C7"];
}


@end
