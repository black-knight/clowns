//
//  Constants.m
//  Clowns
//
//  Created by Daniel Andersen on 19/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "Constants.h"

Constants *sharedConstantsInstance = nil;

@implementation Constants

+ (Constants *)sharedInstance {
    @synchronized (self) {
        if (sharedConstantsInstance == nil) {
            sharedConstantsInstance = [[Constants alloc] init];
        }
        return sharedConstantsInstance;
    }
}

@end
