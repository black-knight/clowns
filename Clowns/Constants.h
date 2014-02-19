//
//  Constants.h
//  Clowns
//
//  Created by Daniel Andersen on 19/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

+ (Constants *)sharedInstance;

@property (nonatomic) float lineWidth;

@property (nonatomic) float borderLeft;
@property (nonatomic) float borderRight;
@property (nonatomic) float borderTop;
@property (nonatomic) float borderBottom;

@end
