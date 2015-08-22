//
// Created by asaake on 15/08/21.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGDateTransformer : NSValueTransformer

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

- (instancetype)initWithDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale;
- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter;

@end