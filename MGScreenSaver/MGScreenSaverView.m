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

        
        [self setAnimationTimeInterval:1/15.0];
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
        
        BOOL inside = CGRectIntersectsRect(adjustedRect, self.bounds);
        if (inside) {
            gifView.frame = adjustedRect;
        }
        else {
            NSLog(@"Replaced gifview: %@", gifView);
            [self replaceGifView:gifView];
        }

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

- (void)replaceGifView:(GifView* )gifView {
    [self.gifViews removeObject:gifView];
    [gifView removeFromSuperview];
    
    [self addRandomGif];
}


- (void)addRandomGif {
    
    if (!self.gifViews) {
        self.gifViews = [NSMutableArray new];
    }
    
    NSArray *gifs = @[[NSURL URLWithString:@"http://media.tumblr.com/51b1a5d240efee5e96b2ea2c60cc6369/tumblr_mvxc0vSF5X1rnq0vfo1_250.gif"],
                      [NSURL URLWithString:@"http://24.media.tumblr.com/0978c70cf361ef3d22a75c9062270554/tumblr_mwjpa9W3qV1qedb29o1_500.gif"],
                      [NSURL URLWithString:@"http://25.media.tumblr.com/d01a23839701119a50ecced55d50dd24/tumblr_mlx481XoKh1qzjoy8o1_400.gif"],
                      [NSURL URLWithString:@"http://24.media.tumblr.com/tumblr_lgj6rdCJje1qf3xzvo1_500.gif"]
                      ];
    
    NSURL *gifURL = gifs[arc4random() % gifs.count];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSImage *image = [[NSImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:gifURL]];
        
        CGSize imageSize = image.size;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GifView *gifView = [[GifView alloc] initWithText:@"A Gif" gifURL:gifURL];
            [self addSubview:gifView];
            
            gifView.frame = CGRectMake(0, 0, imageSize.width + kGifViewTextWidth, imageSize.height);
            
            [self.gifViews addObject:gifView];

        });

    });
    
    
    
}


@end
