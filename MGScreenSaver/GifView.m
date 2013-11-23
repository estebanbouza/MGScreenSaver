//
//  GifView.m
//  MGScreenSaver
//
//  Created by Esteban on 11/23/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import "GifView.h"

@interface GifView ()

@property (nonatomic, strong) NSString *gifText;
@property (nonatomic, strong) NSURL *gifURL;

@property (nonatomic, strong) WebView *webView;
@property (nonatomic, strong) NSTextView *textField;

@property (nonatomic, assign) CGPoint nextOffsetPoint;

@end

@implementation GifView

- (id)initWithText:(NSString *)text gifURL:(NSURL *)gifURL {
    if (self = [super init]) {
        self.gifText = text;
        self.gifURL = gifURL;
        
        self.nextOffsetPoint = CGPointZero;

        self.textField = [[NSTextView alloc] init];
        self.textField.string = self.gifText;
        self.textField.textColor = [NSColor greenColor];
        self.textField.font = [NSFont systemFontOfSize:20.];
        self.textField.backgroundColor = [NSColor clearColor];
        [self.textField setEditable:NO];
        [self addSubview:self.textField];
        
        self.webView = [[WebView alloc] init];
        self.webView.drawsBackground = NO;
        [self addSubview:self.webView];
        [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:self.gifURL]];
        
        [self resizeSubviewsWithOldSize:self.bounds.size];
    }
    return self;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [super layout];
    
    CGRect bounds = self.bounds;
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(bounds)*0.5, CGRectGetHeight(bounds));
    self.webView.frame = CGRectMake(CGRectGetWidth(bounds)*0.5, 0, CGRectGetWidth(bounds)*0.5, CGRectGetHeight(self.bounds));
}

- (CGPoint)nextOffsetPoint {
    CGFloat nextX = _nextOffsetPoint.x;
    CGFloat nextY = _nextOffsetPoint.y;

    NSInteger kVarianzeMaxX = 5;
    NSInteger kVarianzeMaxY = 5;
    
    NSInteger kVarianzeMinX = 1;
    NSInteger kVarianzeMinY = 1;
    
    NSInteger varianzeXDiff = kVarianzeMaxX - kVarianzeMinX;
    NSInteger varianzeYDiff = kVarianzeMaxY - kVarianzeMinY;
    
    NSInteger kMaxX = 20.;
    NSInteger kMaxY = 20.;
    
    CGFloat offsetX = (arc4random() % (varianzeXDiff)) - (NSInteger)varianzeXDiff/2;
    offsetX += offsetX > 0 ? kVarianzeMinX : -kVarianzeMinX;
    
    CGFloat offsetY = (arc4random() % (varianzeYDiff)) - (NSInteger)varianzeYDiff/2;
    offsetY += offsetY > 0 ? kVarianzeMinY : -kVarianzeMinY;

    NSLog(@"OffsetX: %f", offsetX);
    
    nextX += offsetX;
    nextY += offsetY;

    nextX = nextX > 0 ? MIN(nextX, kMaxX) : MAX(nextX, -kMaxX);
    nextY = nextY > 0 ? MIN(nextY, kMaxY) : MAX(nextY, -kMaxY);

    _nextOffsetPoint = CGPointMake(nextX, nextY);
    
    NSLog(@"Next offset: %@", NSStringFromPoint(_nextOffsetPoint));
    
    return _nextOffsetPoint;
}


@end
