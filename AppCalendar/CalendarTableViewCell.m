//
//  CalendarTableViewCell.m
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/13.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "CalendarCollectionViewCell.h"
#import "MouthImageFactory.h"
#import "DateModel.h"
@interface CalendarTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *chinaLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearFirstDay;
@end

@implementation CalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//设置年份和月份的数据
- (void)setMouthImages:(NSArray *)imageArray year:(NSUInteger)year {
    self.cellImageArray = imageArray;
    //
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",year];
    //设置今年的农历年名字
    self.chinaLabel.text = [DateModel getChinaYearName:year];
}
- (void)setCellImageArray:(NSArray *)cellImageArray {
    _cellImageArray = cellImageArray;
    
    [self.collectView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString *identifier = @"collectViewCell";
    
    CalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //今天
    
    cell.imageView.image = self.cellImageArray[indexPath.row];
    
    
    return cell;
    
}


@end
