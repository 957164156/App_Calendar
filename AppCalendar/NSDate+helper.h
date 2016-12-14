//
//  NSDate+helper.h
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (helper)

@property (nonatomic,strong,readonly)NSCalendar *calendar;
//年份
- (NSUInteger)YearSForDate;
//
- (NSUInteger)getCurrentYear;

//
- (NSUInteger)datesInMouth;

//周几
- (NSUInteger)daysOfWeek;

//从那一天开始
- (NSDate *)beginningOfYear;

- (NSDate *)endOfYear;

//根据鱼粉年份获取日期
- (NSDate *)dateByAddingValue:(NSUInteger)value forDateKey:(NSString *)key;


//根据年份获取到中国天干地支
+ (NSString *)getChinaYear:(NSUInteger)currentYear;
@end
