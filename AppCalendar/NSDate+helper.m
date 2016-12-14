//
//  NSDate+helper.m
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import "NSDate+helper.h"

@implementation NSDate (helper)

- (NSCalendar *)calendar {
    
    return [NSCalendar currentCalendar];
}
- (NSUInteger)getCurrentYear {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

//年份
- (NSUInteger)YearSForDate {
    //
    NSDateComponents *component = [self.calendar components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

//
- (NSUInteger)datesInMouth {
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    return range.length;
}

//周几
- (NSUInteger)daysOfWeek {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitWeekday fromDate:self];
    
    return (component.weekday) % 7;
}

//从那一天开始
- (NSDate *)beginningOfYear {
    //
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:self];
    
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)endOfYear {
    //
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setYear:1];
    //
    NSDate *date = [[self.calendar dateByAddingComponents:component toDate:[self beginningOfYear] options:0] dateByAddingTimeInterval:-1];
    return date;
}

- (NSDate *)dateByAddingValue:(NSUInteger)value forDateKey:(NSString *)key {
    //
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setValue:@(value) forKey:key];
    NSDate *date = [self.calendar dateByAddingComponents:component toDate:self options:0];
    return date;
}
//根据年份获取到中国天干地支
+ (NSString *)getChinaYear:(NSUInteger)currentYear {
    NSArray *sTG = @[@"癸",@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"任"];
    NSArray *sDZ = @[@"亥",@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌"];
    NSArray *sSX = @[@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗"];
    //根据年份得到天干
    NSString *TG = @"甲";
    if ((currentYear - 3) % 10 < 10) {
       TG = sTG[(currentYear - 3) % 10];
    }
    //得到地支和生肖
    NSString *DZ = sDZ[(currentYear - 3) % 12];
    NSString *SX = sSX[(currentYear - 3) % 12];
    
    return [NSString stringWithFormat:@"%@%@%@年",TG,DZ,SX];
    
}
@end
