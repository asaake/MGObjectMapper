//
// Created by asaake on 15/08/22.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import "MGURLTransformer.h"


@implementation MGURLTransformer {

}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (![value isKindOfClass:[NSString class]]) [NSException raise:NSInvalidArgumentException format:@"transformedValue only accepts NSString."];
    return [[NSURL alloc] initWithString:value];
}

- (id)reverseTransformedValue:(id)value
{
    if (![value isKindOfClass:[NSURL class]]) [NSException raise:NSInvalidArgumentException format:@"reverseTransformedValue only accepts NSURL."];
    return [((NSURL *)value) absoluteString];
}

@end