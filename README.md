# MGObjectMapper
Objective-C JSON, Dictionary Mapping Library.

Usage

```objc
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
```

```objc
NSDictionary *jsonData = @{
        @"my_name": @"taro",
        @"age": @(30),
        @"is_adult": @(YES),
        @"order": @1
};
MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
[object name] #=> taro
[object age]  #=> 30
```
