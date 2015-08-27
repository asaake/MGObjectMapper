//
// Created by asaake on 15/08/21.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import "MGDateTransformer.h"


@implementation MGDateTransformer {

}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (instancetype)init
{
    return [self initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ" timeZone:nil locale:nil];
}

- (instancetype)initWithDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale
{
    return [self initWithDateFormat:dateFormat timeZone:nil locale:locale];
}

- (instancetype)initWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
    return [self initWithDateFormat:dateFormat timeZone:timeZone locale:nil];
}

- (instancetype)initWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    if (timeZone) dateFormatter.timeZone = timeZone;
    if (locale) dateFormatter.locale = locale;
    return [self initWithDateFormatter:dateFormatter];
}

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    self = [super init];
    if (self) {
        _dateFormatter = dateFormatter;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    if (![value isKindOfClass:[NSString class]]) [NSException raise:NSInvalidArgumentException format:@"transformedValue only accepts NSString."];
    return [self.dateFormatter dateFromString:value];
}

- (id)reverseTransformedValue:(id)value
{
    if (![value isKindOfClass:[NSDate class]]) [NSException raise:NSInvalidArgumentException format:@"reverseTransformedValue only accepts NSDate."];
    return [self.dateFormatter stringFromDate:value];
}

@end