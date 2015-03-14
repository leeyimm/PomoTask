//
//  PomoCycleView.m
//  PomoTask
//
//  Created by Ying on 2/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoCycleView.h"

@implementation PomoCycleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return  nil;
    }
    self.frame = frame;
    return nil;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/2.0;
    center.y = bounds.origin.y + bounds.size.height/2.0;
    float radiusBaseline = MIN(bounds.size.width, bounds.size.height);
    float outterRadius = radiusBaseline * 3.0 /7.0;
    float innerRadius = radiusBaseline *3.0/8.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center radius:outterRadius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    [path moveToPoint:CGPointMake(center.x+ innerRadius, center.y)];
    [path addArcWithCenter:center radius:innerRadius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    path.lineWidth=2;
    [path stroke];
}


@end
