//
//  MGScreenSaverView.m
//  MGScreenSaver
//
//  Created by Esteban on 11/18/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import "MGScreenSaverView.h"

#import "GifView.h"

static  NSString * const kDatabasePath = @"/Users/esteban/myprojects/MGScreenSaver/MGScreenSaver/main.db";

static NSInteger kNumberOfGifs = 7;

@interface MGScreenSaverView ()

@property (nonatomic, strong) NSMutableArray *gifViews;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation MGScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        NSLog(@"Date built %s %s", __DATE__, __TIMESTAMP__);
        
        for (NSInteger i = 0; i < kNumberOfGifs; i++) {
            [self addRandomGif];
        }
        
        [self setAnimationTimeInterval:1/8.0];
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
        CGRect adjustedRect = CGRectOffset(currentRect, offset.x, offset.y);
        CGRect screenRect = CGRectInset(self.bounds, -100, -100);
        
        BOOL inside = CGRectIntersectsRect(adjustedRect, screenRect);
        if (inside) {
            gifView.frame = adjustedRect;
        }
        else {
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
    
    
    NSDictionary *gifDict = [self nextRandomGifInfo];
    
    NSURL *gifURL = gifDict[@"gifLink"];
    NSString *gifText = gifDict[@"gifExplanation"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSImage *image = [[NSImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:gifURL]];
        
        CGSize imageSize = image.size;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GifView *gifView = [[GifView alloc] initWithText:gifText gifURL:gifURL];
            [self addSubview:gifView];
            
            gifView.frame = CGRectMake(arc4random()%(int)((CGRectGetWidth(self.bounds) - imageSize.width - kGifViewTextWidth)),
                                       CGRectGetHeight(self.bounds),
                                       imageSize.width + kGifViewTextWidth,
                                       imageSize.height);
            
            [self.gifViews addObject:gifView];

        });

    });
    
}

- (NSDictionary *)nextRandomGifInfo {
    if (!self.database) {
        self.database = [FMDatabase databaseWithPath:kDatabasePath];
        if (![self.database open]) {
            [NSException raise:@"Couldn't open database" format:nil];
        }
    }

    FMResultSet *rs = [self.database executeQuery:@"select body_xml from messages where body_xml like '%http%.gif%' or body_xml like '%http%.jpeg%' or body_xml like '%http%.jpg%' or body_xml like '%http%.png%' order by random() limit 1"];
    
    [rs next];
    
    NSString *textResult = [rs stringForColumn:@"body_xml"];
    
    NSRegularExpression *gifRegex = [NSRegularExpression regularExpressionWithPattern:@"(.*)<a href=.*(http.*(gif|png|jpeg|jpg)).*a>(.*)" options:0 error:nil];
    
    NSArray *matches = [gifRegex matchesInString:textResult options:0 range:NSMakeRange(0, textResult.length)];
    NSString *gifLink = nil;
    NSString *gifExplanation = [NSString string];

    
    if (matches > 0) {
        gifLink = [textResult substringWithRange:[matches[0] rangeAtIndex:2]];

        gifExplanation = [gifExplanation stringByAppendingString:[textResult substringWithRange:[matches[0] rangeAtIndex:1]]];
        gifExplanation = [gifExplanation stringByAppendingString:[textResult substringWithRange:[matches[0] rangeAtIndex:4]]];
    }
    
    
    return @{@"gifLink" : [NSURL URLWithString:gifLink],
             @"gifExplanation" : gifExplanation};
    
}


@end
