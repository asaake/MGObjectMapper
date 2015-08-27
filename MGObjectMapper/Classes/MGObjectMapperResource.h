//
// Created by asaake on 2015/02/11.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGObjectMapperResource <NSObject>

@required
+ (NSDictionary *)keyPathsByPropertyKey;

@optional
+ (NSDictionary *)defaultPropertyValues;
+ (NSDictionary *)transformersByPropertyKey;
+ (NSDictionary *)importSelectorsByPropertyKey;
+ (NSDictionary *)nullObjectSkipsByPropertyKey;

@end