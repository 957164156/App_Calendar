//
//  DateModel.h
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^Complete)(NSArray *images,BOOL isSucess);
@interface DateModel : NSObject


//制作月份的图片
- (void)makeMouthImageWithDate:(NSDate *)date size:(CGSize)size complete:(Complete)complete;
//设置年份
- (NSDate *)setYear:(NSInteger)year;
//得到当前年的年份
- (NSInteger)getCurrentYear;
//获取到农历年名字
+ (NSString *)getChinaYearName:(NSUInteger)year;

@end
