//
// Created by asaake on 2015/02/11.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Kiwi.h>
#import "MGObjectMapper.h"
#import "MGDateTransformer.h"
#import "MGURLTransformer.h"
#import "MGObjectTransformer.h"

@interface MGMockObject : NSObject<MGObjectMapperResource>
@property (nonatomic) NSString *name;
@property (nonatomic) NSUInteger age;
@property (nonatomic) BOOL isAdult;
@property (nonatomic) NSNumber *order;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *selectorName;
@property (nonatomic) NSString *reSelectorName;
@property (nonatomic) MGMockObject *relatedObject;
@property (nonatomic) NSArray *relatedArrayObject;
@end

@implementation MGMockObject

+ (NSDictionary *)keyPathsByPropertyKey
{
    return @{
            @"name": @"my_name",
            @"age": @"age",
            @"isAdult": @"is_adult",
            @"order": @"order",
            @"date": @"date",
            @"url": @"url",
            @"selectorName": @"selector_name",
            @"relatedObject": @"related_object",
            @"relatedArrayObject": @"related_array_object"
    };
}

+ (NSDictionary *)transformersByPropertyKey
{
    return @{
            @"date": [[MGDateTransformer alloc] init],
            @"url": [[MGURLTransformer alloc] init],
            @"relatedObject": [[MGObjectTransformer alloc] initWithClass:[MGMockObject class]],
            @"relatedArrayObject": [[MGObjectTransformer alloc] initWithClass:[MGMockObject class]]
    };
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{
            @"name": @"none_name",
            @"date": [NSDate dateWithTimeIntervalSince1970:0]
    };
}

+ (NSDictionary *)importSelectorsByPropertyKey
{
    return @{
            @"selectorName": [NSValue valueWithPointer:@selector(importSelectorNameValue:)]
    };
}

- (void)importSelectorNameValue:(id)value
{
    self.selectorName = [((NSString *)value) stringByAppendingString:@"Selector"];
    self.reSelectorName = self.selectorName;
}

@end

@interface MGMockNullSkipObject : NSObject<MGObjectMapperResource>
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *memo;
@end

@implementation MGMockNullSkipObject

+ (NSDictionary *)keyPathsByPropertyKey
{
    return @{
            @"id": @"id",
            @"name": @"name",
            @"memo": @"memo"
    };
}

+ (NSDictionary *)nullObjectSkipsByPropertyKey
{
    return @{
            @"name": @(YES),
            @"memo": @(NO)
    };
}

@end

@interface MGMockAllNullSkipObject : NSObject<MGObjectMapperResource>
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *memo;
@end

@implementation MGMockAllNullSkipObject

+ (NSDictionary *)keyPathsByPropertyKey
{
    return @{
            @"id": @"id",
            @"name": @"name",
            @"memo": @"memo"
    };
}

+ (NSDictionary *)nullObjectSkipsByPropertyKey
{
    return [MGObjectMapper nullObjectAllSkips];
}

@end

SPEC_BEGIN(MGObjectMapperSpec)

    describe(@"MGObjectMapper", ^{

        it(@"クラスからオブジェクトを生成する場合は、デフォルト値が設定されている", ^{
            NSDictionary *defaultPropertyValues = [MGMockObject defaultPropertyValues];
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:@{}];
            [[object.name should] equal:defaultPropertyValues[@"name"]];
            [[object.date should] equal:defaultPropertyValues[@"date"]];
        });

        it(@"基本データ型のJSONデータをマッピングできる", ^{
            NSDictionary *jsonData = @{
                    @"my_name": @"taro",
                    @"age": @(30),
                    @"is_adult": @(YES),
                    @"order": @1
            };
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
            [[object.name should] equal:jsonData[@"my_name"]];
            [[theValue(object.age) should] equal:@30];
            [[theValue(object.isAdult) should] beYes];
            [[object.order should] equal:@1];
        });

        it(@"データのルートが配列のデータを取り込める", ^{
            NSArray *arrayData = @[
                    @{
                            @"my_name": @"taro"
                    },
                    @{
                            @"my_name": @"jiro"
                    }
            ];
            NSArray *result = [MGObjectMapper modelOfClass:MGMockObject.class fromArray:arrayData];
            [[[result[0] name] should] equal:arrayData[0][@"my_name"]];
            [[[result[1] name] should] equal:arrayData[1][@"my_name"]];
        });

        it(@"NSValueTransformerを利用して、値の変換ができる", ^{
            NSDictionary *jsonData = @{
                    @"date": @"2015-01-01T00:00:00.000+000",
                    @"url": @"http://localhost:8080"
            };
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
            NSDate *date = object.date;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            NSDateComponents *components = [calendar components:
                            NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
                                    NSCalendarUnitTimeZone
                                                       fromDate:date];
            [[@([components year]) should] equal:@2015];
            [[@([components month]) should] equal:@1];
            [[@([components day]) should] equal:@1];
            [[@([components hour]) should] equal:@0];
            [[@([components minute]) should] equal:@0];
            [[@([components second]) should] equal:@0];
            [[[components timeZone] should] equal:calendar.timeZone];

            [[object.url.absoluteString should] equal:@"http://localhost:8080"];
        });

        it(@"importSelectorを利用して、値の設定を自由に行うことができる", ^{
            NSDictionary *jsonData = @{
                    @"selector_name": @"My"
            };
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
            [[object.selectorName should] equal:@"MySelector"];
            [[object.reSelectorName should] equal:@"MySelector"];
        });

        it(@"ネストしたオブジェクトの値を設定できる", ^{
            NSDictionary *jsonData = @{
                    @"my_name": @"taro",
                    @"related_object": @{
                            @"my_name": @"jiro",
                            @"related_object": @{
                                    @"my_name": @"saburo"
                            }
                    }
            };
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
            [[object.name should] equal:@"taro"];
            [[object.relatedObject should] beNonNil];
            [[object.relatedObject.name should] equal:@"jiro"];
            [[object.relatedObject.relatedObject should] beNonNil];
            [[object.relatedObject.relatedObject.name should] equal:@"saburo"];
        });

        it(@"ネストした配列オブジェクトの値を設定できる", ^{
            NSDictionary *jsonData = @{
                    @"my_name": @"taro",
                    @"related_array_object": @[
                            @{
                                    @"my_name": @"jiro1",
                                    @"related_array_object": @[
                                            @{
                                                    @"my_name": @"jiro1_saburo1"
                                            },
                                            @{
                                                    @"my_name": @"jiro1_saburo2"
                                            }
                                    ]
                            },
                            @{
                                    @"my_name": @"jiro2",
                                    @"related_array_object": @[
                                    @{
                                            @"my_name": @"jiro2_saburo1"
                                    },
                                    @{
                                            @"my_name": @"jiro2_saburo2"
                                    }
                            ]
                            }
                    ]
            };
            MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
            [[object.name should] equal:@"taro"];
            [[@([object.relatedArrayObject count]) should] equal:@2];
            [[[object.relatedArrayObject[0] name] should] equal:@"jiro1"];
            [[[object.relatedArrayObject[1] name] should] equal:@"jiro2"];
            [[@([[object.relatedArrayObject[0] relatedArrayObject] count]) should] equal:@2];
            [[[[object.relatedArrayObject[0] relatedArrayObject][0] name] should] equal:@"jiro1_saburo1"];
            [[[[object.relatedArrayObject[0] relatedArrayObject][1] name] should] equal:@"jiro1_saburo2"];
            [[@([[object.relatedArrayObject[1] relatedArrayObject] count]) should] equal:@2];
            [[[[object.relatedArrayObject[1] relatedArrayObject][0] name] should] equal:@"jiro2_saburo1"];
            [[[[object.relatedArrayObject[1] relatedArrayObject][1] name] should] equal:@"jiro2_saburo2"];

        });

        it(@"Nullオブジェクトをスキップできることを確認する", ^{

            NSDictionary *data = @{
                    @"id": [NSNull null],
                    @"name": [NSNull null],
                    @"memo": [NSNull null]
            };
            MGMockNullSkipObject *object = [[MGMockNullSkipObject alloc] init];
            object.id = @"1";
            object.name = @"taro";
            object.memo = @"memo";
            [MGObjectMapper modelOfObject:object fromDictionary:data];

            [[object.id should] equal:[NSNull null]];
            [[object.name should] equal:@"taro"];
            [[object.memo should] equal:[NSNull null]];
        });

        it(@"Nullオブジェクトを全てスキップできることを確認する", ^{

            NSDictionary *data = @{
                    @"id": @"1",
                    @"name": [NSNull null],
                    @"memo": [NSNull null]
            };
            MGMockAllNullSkipObject *object = [[MGMockAllNullSkipObject alloc] init];
            object.name = @"taro";
            object.memo = @"memo";
            [MGObjectMapper modelOfObject:object fromDictionary:data];

            [[object.id should] equal:@"1"];
            [[object.name should] equal:@"taro"];
            [[object.memo should] equal:@"memo"];
        });

    });

SPEC_END