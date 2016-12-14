//
//  DateModel.m
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import "DateModel.h"
#import "MouthImageFactory.h"
#import "NSDate+helper.h"

NSUInteger YearMouths = 12;
@interface DateModel()

@property (nonatomic,strong)MouthImageFactory *imageFatory;

//
@property (nonatomic,strong)NSDate *currentDate;
@end

@implementation DateModel

- (instancetype)init {
    if (self = [super init]) {
        
        _currentDate = [NSDate date];
        
    }
    return self;
}
- (NSDate *)setYear:(NSInteger)year {
    NSUInteger currentYear = [_currentDate YearSForDate];
    NSDate *date = [_currentDate dateByAddingValue:(currentYear + year) forDateKey:@"year"];
    return date;
}
//获取到农历年名字
+ (NSString *)getChinaYearName:(NSUInteger)year {
    return [NSDate getChinaYear:year];
}
//得到当前年的年份
- (NSInteger)getCurrentYear {
    
    return [_currentDate YearSForDate];
}
//制作月份的图片
- (void)makeMouthImageWithDate:(NSDate *)date size:(CGSize)size complete:(Complete)complete {
    //一年中的第一天
    NSDate *beginningYear = [date beginningOfYear];
    
    
    //用于存放图片的数组
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i =0; i < YearMouths; i++) {
        //获取这一年中的日期
        NSDate *mouthDate = [beginningYear dateByAddingValue:i forDateKey:@"month"];
        UIImage *image = [[MouthImageFactory shareMotuhFactory] imageMouthWithDate:mouthDate osSize:size];
        
        if (image) {
            [imageArray addObject:image];
        }
    }
    if (complete) {
        complete(imageArray,YES);
    }
}
@end
