//
//  DateByItemView.m
//  chartView
//
//  Created by rsaif on 13-10-8.
//  Copyright (c) 2013年 rsaif. All rights reserved.
//
#import "Config.h"
#import "DateByItemView.h"
#define view_width  22
#define Max_Height  (self.height-BOTTOM_HEIGHT)

#define BAR_WIDTH_DEFAULT 40
#define BAR_SPACES_DEFAULT 10
#define VERTICALE_DATA_SPACES 10
#define BOTTOM_HEIGHT 20


@implementation DateByItemView
@synthesize dateArray;
@synthesize ItemArray;
@synthesize dataArray;

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor =[UIColor clearColor];
    contentView = [[UIView alloc]init];
    //contentView.backgroundColor = [UIColor lightGrayColor];
    contentSV = [[UIScrollView alloc]init];
    //contentSV.backgroundColor = [UIColor redColor];
    [self addSubview:contentSV];
    [contentSV addSubview:contentView];
    contentSV.showsVerticalScrollIndicator = NO;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    contentSV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self filter];
    ItemShowViewArray = [[NSMutableArray alloc]init];
    
    contentView.frame = CGRectMake(0, 0, (VERTICALE_DATA_SPACES+view_width)*[ItemArray count]+VERTICALE_DATA_SPACES, self.frame.size.height);
    [contentSV setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height)];
    [self initDate];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
}

-(void)showDate
{
    [self filter];
    [self initDate];
}

-(void)initDate
{
    for (UIView *viewsub in contentView.subviews) {
        [viewsub removeFromSuperview];
        [ItemShowViewArray removeAllObjects];
    }
    NSUInteger count = [dateArray count];
    NSUInteger row_Inter = VERTICALE_DATA_SPACES;
    int maxIndex = [self getMaxIndex:ItemArray];
    for (int i = 0 ; i< [dateArray count]; i++) {
        NSUInteger x = (i+1)*row_Inter+i*view_width;
        
        NSInteger maxValue = self.type? 80*60:80;//[[ItemArray objectAtIndex:maxIndex] intValue];
        CGFloat height= [[ItemArray objectAtIndex:i] intValue]/60*Max_Height/maxValue;
        height = height<1?1:height;
        height = height>Max_Height?Max_Height:height;
        //底色
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, self.height - height - BOTTOM_HEIGHT, view_width, height)];
        view.backgroundColor = [UIColor colorWithRed:50/255.0 green:143/255.0 blue:222/255.0 alpha:1];
        view.layer.shadowColor= [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.2;
        view.layer.shadowOffset =CGSizeMake(0.0, 1.0);
        view.tag = i+1;
        //点击区域
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, 0, view_width, BAR_SPACES_DEFAULT+Max_Height);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(showValue:) forControlEvents:UIControlEventTouchUpInside];
        //底部表示

        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(x-VERTICALE_DATA_SPACES/2, self.height-BOTTOM_HEIGHT, view_width+VERTICALE_DATA_SPACES, BOTTOM_HEIGHT)];
        contentLabel.font = [UIFont systemFontOfSize:10.0f];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = [dateArray objectAtIndex:i];
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        //contentLabel.transform=CGAffineTransformRotate(contentLabel.transform,M_PI/2);
        [contentView addSubview:contentLabel];
        [ItemShowViewArray addObject:view];
        [contentView addSubview:view];
        [contentView addSubview:btn];

    }
    //画线
    //画水平线
    [self addLine:0 tox:contentView.width  y:self.height-BOTTOM_HEIGHT toY:self.height-BOTTOM_HEIGHT];
    //画 垂直线
    //[self addLine:35 tox:40+Max_Height y:self.frame.origin.y+VERTICALE_DATA_SPACES/2 toY:self.frame.origin.y+VERTICALE_DATA_SPACES/2];
    //添加最值
    //UILabel *maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(35+Max_Height,BAR_SPACES_DEFAULT-VERTICALE_DATA_SPACES/2 , view_width*2, view_width*2)];
    UILabel *maxLabel = [[UILabel alloc]init];
    maxLabel.bounds = CGRectMake(0, 0, view_width, view_width);
    maxLabel.center = CGPointMake(10, 10);
    maxLabel.font = [UIFont systemFontOfSize:10.0f];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.text = [ItemArray objectAtIndex:maxIndex];
    maxLabel.textColor = [UIColor darkGrayColor];
    maxLabel.backgroundColor = [UIColor clearColor];
    //maxLabel.transform=CGAffineTransformRotate(maxLabel.transform,M_PI/2);
    //[self addSubview:maxLabel];
    
}

-(void)addLine:(int)x tox:(int)toX y:(int)y toY:(int)toY
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = 0.5f;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.strokeColor = [UIColor darkGrayColor].CGColor;

    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [contentSV.layer addSublayer:lineShape];
}

-(int)getMaxIndex:(NSArray *)array
{
    int MaxValue=[[array objectAtIndex:0] intValue];
    int length = array.count;
    int maxIndex = 0;
    for (int i=1; i< length; i++) {
        if ([[array objectAtIndex:i] intValue] > MaxValue) {
            MaxValue =[[array objectAtIndex:i] intValue];
            maxIndex = i;
        }
    }
    return maxIndex;
}
//按钮点击事件
-(void)showValue:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIView  *view = [ItemShowViewArray objectAtIndex:btn.tag-1];
    CGPoint center;
    if (lastTapView) {
        lastTapView.backgroundColor = [UIColor colorWithRed:50/255.0 green:143/255.0 blue:222/255.0 alpha:1];
        if (lastTapView != view) {
            view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];;
            lastTapView = view;
            selected = YES;
            
            center = view.center;
            valueLabel.text = [NSString stringWithFormat:@"%d",[[ItemArray objectAtIndex:lastTapView.tag-1] intValue]];
            valueLabel.bounds = CGRectMake(0, 0, view_width*2, view_width);
            valueLabel.center = CGPointMake(center.x, view.frame.origin.y-view_width/2);

        }else{
            if (selected) {
                selected = NO;
                view.backgroundColor = [UIColor colorWithRed:50/255.0 green:143/255.0 blue:222/255.0 alpha:1];
                valueLabel.bounds = CGRectMake(0, 0, 0, 0);
            }else{
                selected = YES;
                view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];
                center = view.center;
                //valueLabel.frame = CGRectMake(rect.origin.x+rect.size.width,rect.origin.y-view_width , view_width*2, view_width*2);
                valueLabel.bounds = CGRectMake(0, 0, view_width*2, view_width);
                valueLabel.center = CGPointMake(center.x, view.frame.origin.y-view_width/2);

            }
        }
    }else{
        view.backgroundColor = [UIColor colorWithRed:118/255.0 green:207/255.0 blue:244/255.0 alpha:1];;
        lastTapView = view;
        selected = YES;
        
        center = view.center;
        //添加值标签
        valueLabel = [[UILabel alloc]init];
        valueLabel.font = [UIFont systemFontOfSize:10.0f];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%d",[[ItemArray objectAtIndex:lastTapView.tag-1] intValue]];
        valueLabel.bounds = CGRectMake(0, 0, view_width*2, view_width);
        valueLabel.center = CGPointMake(center.x, view.frame.origin.y-view_width/2);
        valueLabel.textColor = [UIColor darkGrayColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        //[contentView addSubview:valueLabel];

    }
    NSLog(@"%@",valueLabel);
}
-(void)filter
{
    NSMutableArray  *array1 = [dataArray objectAtIndex:0];
    NSMutableArray  *array2 = [dataArray objectAtIndex:1];
    int count1 = [array1 count];
    int count2 = [array2 count];
    if (count1 == count2) {
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [dataArray objectAtIndex:1];
    }else if (count1 < count2){
        NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
        for (int i = 0; i< count1; i++) {
            [tmp1 addObject:[array2 objectAtIndex:i]];
        }
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [NSArray arrayWithArray:tmp1];
        
    }else{
        NSMutableArray *tmp1 = [NSMutableArray arrayWithArray:[dataArray objectAtIndex:1]];
        
        for (int i = count2; i< count1; i++) {
            [tmp1 addObject:@"0"];
        }
        dateArray = [dataArray objectAtIndex:0];
        ItemArray = [NSArray arrayWithArray:tmp1];
    }
    
}
@end
