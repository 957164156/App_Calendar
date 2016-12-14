//
//  ViewController.m
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/12.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import "ViewController.h"
#import "CalendarTableViewCell.h"
#import "DateModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger _offset;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据
@property (nonatomic,strong)DateModel *model;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = [UIScreen mainScreen].bounds.size.height - 64 - 44;
    self.model = [[DateModel alloc] init];
    _offset = -1;
  
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //滚动到中间
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tableViewCell";
    
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSDate *date = [_model setYear:((_offset * 20 * 0.5) + (indexPath.row))];
    
    [self.model makeMouthImageWithDate:date size:CGSizeMake(110, 120) complete:^(NSArray *images, BOOL isSucess) {
        if (isSucess && images.count > 0) {
            [cell setMouthImages:images year:[_model getCurrentYear] + ((_offset * 20 * 0.5) + (indexPath.row))];
        }
    }];
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint contentOffset  = scrollView.contentOffset;
    NSUInteger CellHeight = [UIScreen mainScreen].bounds.size.height - 64 - 44;
    if (contentOffset.y <= CellHeight) {
        contentOffset.y = scrollView.contentSize.height / 2 + CellHeight;
        _offset--;
    } else if (contentOffset.y >= scrollView.contentSize.height - (CellHeight << 1)) {
        contentOffset.y = scrollView.contentSize.height / 2 - (CellHeight << 1);
        _offset++;
    }
    
    [scrollView setContentOffset:contentOffset];
}
@end
