//
//  MouthImageFactory.m
//  AppCalendar
//
//  Created by 孙明卿 on 2016/12/14.
//  Copyright © 2016年 爱书人. All rights reserved.
//

#import "MouthImageFactory.h"
#import "NSDate+helper.h"
#import "INOMonthGlyphsHelper.h"
#import <CoreText/CoreText.h>
static NSUInteger const kMonthDaysColumns = 7;
static NSUInteger const kMonthDaysRows    = 6;
@interface MouthImageFactory()
@property (nonatomic, strong) NSDateFormatter *monthTitleDateFormatter;
@property (nonatomic, strong) INOMonthGlyphsHelper *glyphsHelper;

@end
static MouthImageFactory *factory = nil;
@implementation MouthImageFactory
+ (instancetype)shareMotuhFactory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[self alloc] init];
    });
    return factory;
}

+ (id)alloc {
    @synchronized([MouthImageFactory class]) {
        NSAssert(factory == nil, @"Attempted to allocate a second instance of the INOMonthImageFactory singleton");
        factory = [super alloc];
        return factory;
    }
    return nil;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        _monthTitleDateFormatter = [[NSDateFormatter alloc] init];
        [_monthTitleDateFormatter setDateFormat:@"LLLL"];
        
        _glyphsHelper = [INOMonthGlyphsHelper glyphHelperWithFontName:@"Helvetica" fontSize:8.0f];

    }
    
    return self;
}

//根据月份来制造图片

- (UIImage *)imageMouthWithDate:(NSDate *)date osSize:(CGSize)size {
    if (!CGSizeEqualToSize(CGSizeZero,size)) {
        //创建画板
        CGContextRef ctf = CGContextCreate(size);
        //在画板上添加内容
        UIImage *image = UIGraphicsGetImageFromContext([self DrawMouthInContent:ctf mouthDate:date ofSize:size eventsForDate:nil]);
        CGContextRelease(ctf);
        //
        return image;
    }
    
    
    return nil;
}

//画
- (CGContextRef)DrawMouthInContent:(CGContextRef)ctf mouthDate:(NSDate *)mouthDate ofSize:(CGSize)size eventsForDate:(NSDictionary *)events {
    //月份的高度
    CGFloat mouthNameHeight = 20.0f;
    CGRect monthNameFrame = CGRectMake(0.0f, 0.0f, size.width, mouthNameHeight);
    //天数的size
    CGSize datesAreaSize = CGSizeMake(size.width, size.height - mouthNameHeight);
    //每一天的size
    CGSize dateSize = CGSizeMake(datesAreaSize.width / kMonthDaysColumns, datesAreaSize.height / kMonthDaysRows);
    //获取今天是周几
    NSUInteger weekDates = [mouthDate daysOfWeek];
    CGPoint   *glyphPositions = (CGPoint *)malloc(sizeof(CGPoint) * _glyphsHelper.length);
    //
    NSUInteger glyphIterator = 0;
    //一个月有多少天
    NSUInteger daysInMouth = [mouthDate datesInMouth];
    //
    for (int i =0; i < daysInMouth; i++) {
        //确定这一天在第几列
        CGPoint offset = CGPointMake(weekDates % kMonthDaysColumns,
                                     weekDates / kMonthDaysColumns);
        
        if (i < kSignleFigureGlyphsCount) {
            CGSize glyphAdvance = _glyphsHelper.glyphAdvances[glyphIterator];
            CGPoint position = CGPointMake(offset.x * dateSize.width + 0.5 * (dateSize.width - glyphAdvance.width),
                                           (datesAreaSize.height - (offset.y + 1) * dateSize.height) + 0.5 * (dateSize.height - glyphAdvance.height));
            glyphPositions[glyphIterator++] = position;

        } else {
            CGSize firstFigureGlyphAdvance = _glyphsHelper.glyphAdvances[glyphIterator];
            CGSize secondFigureGlyphAdvance = _glyphsHelper.glyphAdvances[glyphIterator + 1];
            
            CGFloat glyphPositionY = (datesAreaSize.height - (offset.y + 1) * dateSize.height) + 0.5 * (dateSize.height - firstFigureGlyphAdvance.height);
            
            glyphPositions[glyphIterator++] = CGPointMake(offset.x * dateSize.width + 0.5 * (dateSize.width - firstFigureGlyphAdvance.width) - 0.5 *secondFigureGlyphAdvance.width,
                                                          glyphPositionY);
            
            glyphPositions[glyphIterator++] = CGPointMake(offset.x * dateSize.width + 0.5 * (dateSize.width - secondFigureGlyphAdvance.width) + 0.5 * firstFigureGlyphAdvance.width,
                                                          glyphPositionY);
        }
                 weekDates++;
    }
    // Glyphs drawing
    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, size.height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGContextSetTextMatrix(ctf, transform);
    
    CGContextSetFillColorWithColor(ctf, [UIColor blackColor].CGColor);
    CTFontDrawGlyphs(_glyphsHelper.font, _glyphsHelper.glyphs, glyphPositions, glyphIterator, ctf);
    free(glyphPositions);
    
    // Drawing month title
    [self drawMonthTitleInContext:ctf inRect:monthNameFrame monthName:[_monthTitleDateFormatter stringFromDate:mouthDate]];
    
    return ctf;
    
}
- (void)drawMonthTitleInContext:(CGContextRef)ctx inRect:(CGRect)rect monthName:(NSString *)monthName {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    NSDictionary *attributes = @{(id)kCTForegroundColorAttributeName : (id)[UIColor colorWithRed:1.0f green:59 / 255.0f blue:48 / 255.0f alpha:1.0f].CGColor,
                                 NSFontAttributeName                 : [UIFont systemFontOfSize:12.0f]};
    NSAttributedString* attString = [[NSAttributedString alloc] initWithString:monthName
                                                                    attributes:attributes];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CTFrameDraw(frame, ctx);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
}


CG_INLINE CGContextRef CGContextCreate(CGSize size) {
    
    //获取屏幕分辨率
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    //创建色彩空间
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //创建画板
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width * scaleFactor, size.height * scaleFactor, 8, size.width * 2 * (CGColorSpaceGetNumberOfComponents(space) + 1), space, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    //缩放做标轴
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    //允许上下文在各个保真度等级插入像素，传递kCGInterpolationHigh参数用来获得最优的结果
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    //为当前视图添加抗锯齿处理
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetAllowsAntialiasing(ctx, YES);
    //
    CGColorSpaceRelease(space);
    
    return ctx;
    
}

CG_INLINE UIImage* UIGraphicsGetImageFromContext(CGContextRef ctx) {
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage* image = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    
    return image;
    
}

@end
