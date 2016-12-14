//
//  MouthImageFactory.h
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MouthImageFactory : NSObject

//
+ (instancetype)shareMotuhFactory;

- (UIImage *)imageMouthWithDate:(NSDate *)date osSize:(CGSize)size;
@end
