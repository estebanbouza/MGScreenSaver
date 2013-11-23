//
//  MGScreenSaverView.m
//  MGScreenSaver
//
//  Created by Esteban on 11/18/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import "MGScreenSaverView.h"
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

@interface MGScreenSaverView ()

@property (nonatomic, strong) WebView *webView;

@end

@implementation MGScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        self.webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
        self.webView.drawsBackground = NO;
        [self addSubview:self.webView];
        [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://media.tumblr.com/51b1a5d240efee5e96b2ea2c60cc6369/tumblr_mvxc0vSF5X1rnq0vfo1_250.gif"]]];
        
        [self setAnimationTimeInterval:1/3.0];
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

@end
