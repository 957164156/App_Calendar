//
//  CalendarTableViewCell.h
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/13.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell

//月份数据
@property (nonatomic,strong)NSArray *cellImageArray;

//设置年份和月份的数据
- (void)setMouthImages:(NSArray *)imageArray year:(NSUInteger)year;
@end
