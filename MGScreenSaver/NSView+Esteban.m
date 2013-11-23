//
//  NSView+Esteban.m
//  MGScreenSaver
//
//  Created by Esteban on 11/23/13.
//  Copyright (c) 2013 Mobgen. All rights reserved.
//

#import "NSView+Esteban.h"

@implementation NSView (Esteban)

- (NSPoint)center {
    return CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
                       (self.frame.origin.y + (self.frame.size.height / 2)));
}

- (void)setCenter:(NSPoint)center {
    [self setFrameOrigin:CGPointMake(self.frame.origin.x - (self.frame.size.width / 2),
                                     self.frame.origin.y + (self.frame.size.height / 2))];
    
    
}

@end
