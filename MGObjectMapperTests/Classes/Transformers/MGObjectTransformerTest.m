//
// Created by asaake on 15/08/21.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Kiwi.h>
#import "MGObjectTransformer.h"
#import "MGObjectMapperResource.h"

@interface MGObjectTransFormerMockObject : NSObject<MGObjectMapperResource>
@property (nonatomic) NSString *name;
@end

@implementation MGObjectTransFormerMockObject

+ (NSDictionary *)keyPathsByPropertyKey
{
    return @{
            @"name": @"name"
    };
}

@end

SPEC_BEGIN(MGObjectTransformerSpec)

    describe(@"MGObjectTransformer", ^{

        it(@"NSDictionaryを対象のオブジェクトに変換できる", ^{
            MGObjectTransformer *objectTransformer = [[MGObjectTransformer alloc] initWithClass:[MGObjectTransFormerMockObject class]];
            MGObjectTransFormerMockObject *object = [objectTransformer transformedValue:@{@"name": @"taro"}];
            [[object.name should] equal:@"taro"];
        });

    });

SPEC_END