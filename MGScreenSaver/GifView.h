//
//  GifView.h
//  MGScreenSaver
//
//  Created by Esteban on 11/23/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static const CGFloat kGifViewTextWidth = 200;

@interface GifView : NSView

- (id)initWithText:(NSString *)text gifURL:(NSURL *)gifURL;

- (CGPoint)nextOffsetPoint;

@end
