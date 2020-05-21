//
//  PGDatePickerManagerCustomHeaderView.h
//  Demo
//
//  Created by Super Mac on 2019/11/25.
//  Copyright © 2019 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGEnumeration.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^labelHandlerBlock)(PGDatePickLabelStyle style,NSString *dateStr);

typedef void(^ChooseBtnClickBlock)(PGDatePickerMode pickerModel);

typedef void(^FinishBtnClickBlock)(NSString *startTime, NSString *endTime);

@interface PGDatePickerManagerCustomHeaderView : UIView

@property (nonatomic,copy) labelHandlerBlock labelClickBlock;

//@property (nonatomic,copy) labelHandlerBlock endLabelClickBlock;

@property (nonatomic,copy) ChooseBtnClickBlock chooseBtnClickBlock;

@property (nonatomic,copy) FinishBtnClickBlock finishBtnClickBlock;

@property (nonatomic,assign) PGDatePickerMode pickerModel;

@property (nonatomic,strong) NSDateComponents *dateComponents;

@property (nonatomic,assign) PGDatePickLabelStyle style;

@end

NS_ASSUME_NONNULL_END
