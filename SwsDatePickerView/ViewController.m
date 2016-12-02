//
//  ViewController.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "ViewController.h"
#import "SwsDatePickerView.h"

@interface ViewController () <SwsDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - ChooseDate
- (IBAction)chooseDate:(UIButton *)sender {
    
    SwsDatePickerView *dateView = [[SwsDatePickerView alloc] initWithTitle:@"选择日期" delegate:self componentsNum:3 isEndToday:NO];
    [dateView show];
}

#pragma mark - SwsDatePickerViewDelegate
- (void)returnSwsDatePickerViewDateString:(NSString *)dateString swsDatePickerView:(SwsDatePickerView *)swsDatePickerView {
    
    [_button setTitle:dateString forState:UIControlStateNormal];
}

@end
