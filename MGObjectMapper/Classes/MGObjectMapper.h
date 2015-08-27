//
//  MGObjectMapper.h
//  MGObjectMapper
//
//  Created by asaake on 2015/02/11.
//  Copyright (c) 2015 asaake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGObjectMapperResource.h"

@interface MGObjectMapper : NSObject
+ (NSDictionary *)nullObjectAllSkips;
+ (id)modelOfClass:(Class<MGObjectMapperResource>)modelClass fromDictionary:(NSDictionary *)data;
+ (NSArray *)modelOfClass:(Class<MGObjectMapperResource>)modelClass fromArray:(NSArray *)arrayData;
+ (id)modelOfObject:(NSObject <MGObjectMapperResource> *)modelObject fromDictionary:(NSDictionary *)data;
@end
