//
//  MGObjectMapper.m
//  MGObjectMapper
//
//  Created by asaake on 2015/02/11.
//  Copyright (c) 2015 asaake. All rights reserved.
//

#import "MGObjectMapper.h"
#import <objc/message.h>

static NSDictionary *kNullObjectAllSkips;

@implementation MGObjectMapper

+ (void)initialize
{
    kNullObjectAllSkips = [[NSMutableDictionary alloc] init];
}

+ (NSDictionary *)nullObjectAllSkips
{
    return kNullObjectAllSkips;
}

+ (id)modelOfClass:(Class<MGObjectMapperResource>)modelClass fromDictionary:(NSDictionary *)data
{
    // オブジェクトを生成
    NSObject<MGObjectMapperResource> *newObject = (NSObject<MGObjectMapperResource> *)[((id)modelClass) new];

    // デフォルト値がある場合は設定する
    if ([((id)modelClass) respondsToSelector:@selector(defaultPropertyValues)]) {
        NSDictionary *defaultPropertyValues = [modelClass defaultPropertyValues];
        [newObject setValuesForKeysWithDictionary:defaultPropertyValues];
    }

    // オブジェクトにマッピングする
    return [self modelOfObject:newObject fromDictionary:data];
}

+ (NSArray *)modelOfClass:(Class<MGObjectMapperResource>)modelClass fromArray:(NSArray *)arrayData
{
    // 配列からデータを取り出して、オブジェクトにマッピングする
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *data in arrayData) {
        id object = [self modelOfClass:modelClass fromDictionary:data];
        [result addObject:object];
    }
    return result;
}

+ (id)modelOfObject:(NSObject <MGObjectMapperResource> *)modelObject fromDictionary:(NSDictionary *)data
{
    // オブジェクトからモデルクラスを取り出す
    Class<MGObjectMapperResource> modelClass = [modelObject class];

    // 値変換オブジェクトを取得
    NSDictionary *transformers = @{};
    if ([((id) modelClass) respondsToSelector:@selector(transformersByPropertyKey)]) {
        transformers = [modelClass transformersByPropertyKey];
    }

    // 値設定セレクターを取得
    NSDictionary *importSelectors = @{};
    if ([((id) modelClass) respondsToSelector:@selector(importSelectorsByPropertyKey)]) {
        importSelectors = [modelClass importSelectorsByPropertyKey];
    }

    // Nullオブジェクトを飛ばすかどうかを取得する
    NSDictionary *nullObjectSkips = @{};
    if ([((id) modelClass) respondsToSelector:@selector(nullObjectSkipsByPropertyKey)]) {
        nullObjectSkips = [modelClass nullObjectSkipsByPropertyKey];
    }

    // プロパティへマッピング
    NSDictionary *mappings = [modelClass keyPathsByPropertyKey];
    for (NSString *propertyKey in mappings) {

        // JSONデータの取り出し
        NSString *jsonKey = mappings[propertyKey];
        NSObject *jsonValue = data[jsonKey];
        if (jsonValue == nil) continue;

        // Nullオブジェクトを飛ばすかどうか
        if (jsonValue == [NSNull null]
            && (nullObjectSkips == [self nullObjectAllSkips]
                || (nullObjectSkips[propertyKey] && [nullObjectSkips[propertyKey] boolValue]))) continue;

        // 値を変換する
        NSValueTransformer *transformer = transformers[propertyKey];
        if (transformer) {
            jsonValue = [transformer transformedValue:jsonValue];
        }

        // 値を設定する
        NSValue *importSelector = importSelectors[propertyKey];
        if (importSelector) {
            ((void(*)(id, SEL, id))objc_msgSend)(modelObject, [importSelector pointerValue], jsonValue);
        } else {
            [modelObject setValue:jsonValue forKey:propertyKey];
        }
    }

    return modelObject;
}

@end
