# MGObjectMapper
Objective-C JSON, Dictionary Mapping Library.

Usage

```objc
@interface MGMockObject : NSObject<MGObjectMapperResource>
@property (nonatomic) NSString *name;
@property (nonatomic) NSUInteger age;
@end

@implementation MGMockObject

+ (NSDictionary *)keyPathsByPropertyKey
{
    return @{
            @"name": @"my_name",
            @"age": @"age"
    };
}

@end

NSDictionary *jsonData = @{
        @"my_name": @"taro",
        @"age": @(30)
};
MGMockObject *object = [MGObjectMapper modelOfClass:MGMockObject.class fromDictionary:jsonData];
[object name] #=> taro
[object age]  #=> 30
```

## Options
default value

```objc
+ (NSDictionary *)defaultPropertyValues
{
    return @{
            @"name": @"none_name",
            @"date": [NSDate dateWithTimeIntervalSince1970:0]
    };
}
```

transform value
  related objc or objects
```objc
+ (NSDictionary *)transformersByPropertyKey
{
    return @{
            @"date": [[MGDateTransformer alloc] init],
            @"url": [[MGURLTransformer alloc] init],
            @"relatedObject": [[MGObjectTransformer alloc] initWithClass:[MGMockObject class]],
            @"relatedArrayObject": [[MGObjectTransformer alloc] initWithClass:[MGMockObject class]]
    };
}
```

setter value
```objc
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
```
