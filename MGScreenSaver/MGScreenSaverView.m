//
//  MGScreenSaverView.m
//  MGScreenSaver
//
//  Created by Esteban on 11/18/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import "MGScreenSaverView.h"

#import "GifView.h"

@interface MGScreenSaverView ()

@property (nonatomic, strong) NSMutableArray *gifViews;

@end

@implementation MGScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        NSLog(@"Date built %s %s", __DATE__, __TIMESTAMP__);
        
        [self addRandomGif];
        [self addRandomGif];
        [self addRandomGif];
        [self addRandomGif];

        
        [self setAnimationTimeInterval:1/2.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    for (GifView *gifView in self.gifViews) {
        CGPoint offset = [gifView nextOffsetPoint];
        
        CGRect currentRect = gifView.frame;
        NSLog(@"View center: %@", NSStringFromRect(currentRect));
        CGRect adjustedRect = CGRectOffset(currentRect, offset.x, offset.y);
        NSLog(@"View center + offset: %@", NSStringFromRect(adjustedRect));
        
        gifView.frame = adjustedRect;
        
    }
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}


- (void)addRandomGif {
    
    if (!self.gifViews) {
        self.gifViews = [NSMutableArray new];
    }
    
    NSArray *gifs = @[[NSURL URLWithString:@"http://media.tumblr.com/51b1a5d240efee5e96b2ea2c60cc6369/tumblr_mvxc0vSF5X1rnq0vfo1_250.gif"],
                      
                      [NSURL URLWithString:@"http://24.media.tumblr.com/tumblr_lgj6rdCJje1qf3xzvo1_500.gif"]
                      ];
    
    NSURL *gifURL = gifs[arc4random()%gifs.count];
    
    GifView *gifView = [[GifView alloc] initWithText:@"A Gif" gifURL:gifURL];
    [self addSubview:gifView];
    gifView.frame = CGRectMake(0, 0, 600, 600);
    [self.gifViews addObject:gifView];
    
}

- (void)removeGifView:(GifView *)gifView {
    
}

@end
