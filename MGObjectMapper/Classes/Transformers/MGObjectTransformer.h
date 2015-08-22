//
// Created by asaake on 15/08/22.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGObjectMapperResource;


@interface MGObjectTransformer : NSValueTransformer

@property (nonatomic, readonly) Class<MGObjectMapperResource> resourceClass;

- (instancetype)initWithClass:(Class<MGObjectMapperResource>)resourceClass;

@end