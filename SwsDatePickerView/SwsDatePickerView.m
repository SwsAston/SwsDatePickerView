//
//  SwsDatePickerView.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "SwsDatePickerView.h"
#import "AppDelegate.h"

#define Start_Year 1970

#define RowHeight     45

#define Font          15


@interface SwsDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) BOOL isEndToday; // 可选日期是否超过今天
@property (nonatomic, assign) NSInteger compoentsNum; // 列数

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSMutableArray *nowMonthArray;
@property (nonatomic, strong) NSMutableArray *nowDayArray;

@property (nonatomic, assign) NSInteger nowYear;
@property (nonatomic, assign) NSInteger nowMonth;
@property (nonatomic, assign) NSInteger nowDay;

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;

@property (nonatomic, assign) BOOL isFirstReload;

@end

@implementation SwsDatePickerView

- (SwsDatePickerView *)initWithTitle:(NSString *)title
                            delegate:(id)delegate
                       componentsNum:(NSInteger)componentsNum
                          isEndToday:(BOOL)isEndToday {
    
    SwsDatePickerView *swsDatePickerView = [[[NSBundle mainBundle] loadNibNamed:@"SwsDatePickerView" owner:nil options:nil] firstObject];
    
    swsDatePickerView.frame = [UIScreen mainScreen].bounds;
    swsDatePickerView.delegate = delegate;
    swsDatePickerView.isEndToday = isEndToday;
    swsDatePickerView.compoentsNum = componentsNum;
    
    if (title) {
        
        swsDatePickerView.titleLabel.text = [NSString stringWithFormat:@"%@",title];
    } else {
        
        swsDatePickerView.titleLabel.text = @"";
    }
    
    [swsDatePickerView initDataSource];
    return swsDatePickerView;
}

#pragma mark - 初始化数据
- (void)initDataSource {
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    // year
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    _nowYear =[currentyearString intValue];
    
    // month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    _nowMonth =[currentMonthString intValue];
    
    // day
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    _nowDay =[currentDateString intValue];
    
    // yearArray
    _yearArray = [NSMutableArray array];
    if (_isEndToday) {
        
        for (int i = Start_Year; i <= _nowYear; i ++) {
            
            [_yearArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        
        for (int i = Start_Year; i <= _nowYear + 20; i ++) {
            
            [_yearArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    
    // monthArray
    _monthArray = [NSMutableArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    _nowMonthArray = [NSMutableArray array];
    for (int i = 1; i <= _nowMonth; i ++) {
        
        [_nowMonthArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    // dayArray;
    _dayArray = [NSMutableArray array];
    for (int i = 1; i <= 31; i ++) {
        
        [_dayArray addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    _nowDayArray = [NSMutableArray array];
    for (int i = 1; i <= _nowDay; i ++) {
        
        [_nowDayArray addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    
    _isFirstReload = YES;
    
    // pickerView默认选中今天
    if (_isEndToday) {
        
        [_pickerView selectRow:_yearArray.count - 1 inComponent:0 animated:YES];
    } else{
        
        [_pickerView selectRow:_yearArray.count - 1- 20 inComponent:0 animated:YES];
    }
    if (_compoentsNum == 2) {
        
        [_pickerView selectRow:_nowMonth - 1 inComponent:1 animated:YES];
        _selectedMonth = _nowMonth - 1;
        [_pickerView reloadAllComponents];
    }
    if (_compoentsNum == 3) {
        
        [_pickerView selectRow:_nowMonth - 1 inComponent:1 animated:YES];
        [_pickerView selectRow:_nowDay - 1 inComponent:2 animated:YES];
    }
}

#pragma mark - UIPickerViewDatasource/UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return _compoentsNum;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return _yearArray.count;
    } else if (component == 1) {
        
        NSInteger selRow0 = [pickerView selectedRowInComponent:0];
        
        if ((selRow0 == _nowYear - Start_Year && _isEndToday) || _isFirstReload) {
            
            return _nowMonthArray.count;
        } else {
            
            return _monthArray.count;
        }
    } else {
        
        NSInteger selRow0 = [pickerView selectedRowInComponent:0];
        NSInteger selRow1 = [pickerView selectedRowInComponent:1];
        if ((selRow0 == _nowYear - Start_Year && selRow1 == _nowMonth - 1 && _isEndToday) || _isFirstReload) {
            
            return _nowDayArray.count;
        } else {
            
            if (_selectedMonth == 0 || _selectedMonth == 2 || _selectedMonth == 4 || _selectedMonth == 6 || _selectedMonth == 7 || _selectedMonth == 9 || _selectedMonth == 11) {
                
                return 31;
            } else if (_selectedMonth == 1) {
                
                int year = [[_yearArray objectAtIndex:_selectedYear]intValue ];
                
                if(((year % 4 == 0) && (year % 100 !=0)) || (year % 400 == 0)){
                    
                    return 29;
                } else {
                    
                    return 28;
                }
            } else {
                
                return 30;
            }
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return RowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 40 * _compoentsNum) / _compoentsNum, RowHeight)];
    labelView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 40 * _compoentsNum) / _compoentsNum, RowHeight)];
    label.font = [UIFont systemFontOfSize:Font];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [labelView addSubview:label];
    
    if (component == 0) {
        
        label.text = _yearArray[row];
    } else if (component == 1) {
        
        label.text = _monthArray[row];
    } else {
        
        label.text = _dayArray[row];
    }
    return labelView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _isFirstReload = NO;
    
    if (component == 0) {
        
        _selectedYear = row;
        [_pickerView reloadAllComponents];
    } else if (component == 1) {
        
        _selectedMonth = row;
        [_pickerView reloadAllComponents];
    } else {
        
        _selectedDay = row;
        [_pickerView reloadAllComponents];
    }
}

#pragma mark - 点击事件
- (IBAction)buttonPressed:(UIButton *)sender {
    
    // 2 确定
    if (2 == sender.tag) {
        
        NSString *pickString = @"";
        
        if (_compoentsNum == 3) {
            
            pickString = [NSString stringWithFormat:@"%@-%@-%@ ",[_yearArray objectAtIndex:[_pickerView selectedRowInComponent:0]],[_monthArray objectAtIndex:[_pickerView selectedRowInComponent:1]],[_dayArray objectAtIndex:[_pickerView selectedRowInComponent:2]]];
        } else if (_compoentsNum == 2) {
            
            pickString = [NSString stringWithFormat:@"%@-%@",[_yearArray objectAtIndex:[_pickerView selectedRowInComponent:0]],[_monthArray objectAtIndex:[_pickerView selectedRowInComponent:1]]];
        } else {
            
            pickString = [NSString stringWithFormat:@"%@",[_yearArray objectAtIndex:[_pickerView selectedRowInComponent:0]]];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(returnSwsDatePickerViewDateString:swsDatePickerView:)]) {
            
            [_delegate returnSwsDatePickerViewDateString:pickString swsDatePickerView:self];
        }
    }
    [self dismiss];
}

#pragma mark - show / dismiss
- (void)show {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    [window addSubview:self];
    
    __weak SwsDatePickerView *view = self;
    view.alpha = 0;
    _contentView.transform = CGAffineTransformMakeTranslation(0, _contentView.bounds.size.height);
    [UIView animateWithDuration:.2 animations:^{
        
        view.alpha = 1;
        view.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    
    __weak __block SwsDatePickerView *view = self;
    [UIView animateWithDuration:.2 animations:^{
        
        view.alpha = 0;
        view.contentView.transform = CGAffineTransformMakeTranslation(0, view.contentView.bounds.size.height);
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
        view = nil;
    }];
}

@end
