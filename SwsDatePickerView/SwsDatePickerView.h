//
//  SwsDatePickerView.h
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwsDatePickerView;

@protocol SwsDatePickerViewDelegate <NSObject>

@optional

/** 返回日期 */
-(void)returnSwsDatePickerViewDateString:(NSString *)dateString swsDatePickerView:(SwsDatePickerView *)swsDatePickerView;

@end

@interface SwsDatePickerView : UIView

@property (nonatomic, weak) id <SwsDatePickerViewDelegate> delegate;

/**
 *  日期选择器
 *
 *  @param title         title
 *  @param delegate      delegate
 *  @param componentsNum 列数
 *  @param isEndToday    结束时间是否为今天
 *
 *  @return SwsDatePickerView
 */
- (SwsDatePickerView *)initWithTitle:(NSString *)title
                            delegate:(id)delegate
                       componentsNum:(NSInteger)componentsNum
                          isEndToday:(BOOL)isEndToday;

/** show */
- (void)show;

@end
