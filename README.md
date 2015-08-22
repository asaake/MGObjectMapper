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
