//
// Created by asaake on 15/08/22.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import "MGObjectTransformer.h"
#import "MGObjectMapperResource.h"
#import "MGObjectMapper.h"


@implementation MGObjectTransformer {

}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (instancetype)initWithClass:(Class<MGObjectMapperResource>)resourceClass
{
    self = [self init];
    if (self) {
        _resourceClass = resourceClass;
    }
    return self;
}

- (id)transformedValue:(id)value
{
    BOOL kindOfDictionary = [value isKindOfClass:[NSDictionary class]];
    BOOL kindOfArray = [value isKindOfClass:[NSArray class]];
    if (!(kindOfDictionary || kindOfArray)) {
        [NSException raise:NSInvalidArgumentException format:@"transformedValue accepts NSDictionary or NSArray."];
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [MGObjectMapper modelOfClass:self.resourceClass fromDictionary:value];
    } else {
        return [MGObjectMapper modelOfClass:self.resourceClass fromArray:value];
    }
}

@end