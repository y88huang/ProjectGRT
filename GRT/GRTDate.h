//
//  GRTDate.h
//  GRT
//
//  Created by Mike Di on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTDate : NSObject
@property (nonatomic,readonly) NSInteger hour;
@property (nonatomic,readonly) NSInteger minute;
@property (nonatomic,readonly) NSTimeInterval second;

- (id) initWithString:(NSString*) time;

@end
