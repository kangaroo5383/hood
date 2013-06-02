//
//  JLMeeupOverlayView.m
//  movingHelp
//
//  Created by Jessica Lam on 6/2/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLMeeupOverlayView.h"

@implementation JLMeeupOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    UIImage *image = [UIImage imageNamed:@"meetupIcon"];
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    UIGraphicsPushContext(context);
    [image drawInRect:theRect blendMode:kCGBlendModeNormal alpha:1.0];
    UIGraphicsPopContext();
}
@end
