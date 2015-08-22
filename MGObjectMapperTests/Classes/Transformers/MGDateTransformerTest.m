//
// Created by asaake on 15/08/21.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Kiwi.h>
#import "MGDateTransformer.h"

static NSString *const kTimeZoneName = @"Asia/Tokyo";

SPEC_BEGIN(MGDateTransformerSpec)

    describe(@"MGDateTransformer", ^{

        it(@"ISO8601のNSStringをNSDateに変換できる", ^{
            MGDateTransformer *dateTransformer = [[MGDateTransformer alloc] init];
            NSDate *date = [dateTransformer transformedValue:@"2015-01-01T00:01:02.003+0900"];
            [[date should] beNonNil];

            NSCalendar *calendar = [NSCalendar currentCalendar];
            calendar.timeZone = [[NSTimeZone alloc] initWithName:kTimeZoneName];
            NSDateComponents *components = [calendar components:
                            NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
                                    NSCalendarUnitTimeZone
                                     fromDate:date];
            [[@([components year]) should] equal:@2015];
            [[@([components month]) should] equal:@1];
            [[@([components day]) should] equal:@1];
            [[@([components hour]) should] equal:@0];
            [[@([components minute]) should] equal:@1];
            [[@([components second]) should] equal:@2];
            [[[components timeZone] should] equal:calendar.timeZone];

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"SSS";
            NSString *milliSeconds = [dateFormatter stringFromDate:date];
            [[milliSeconds should] equal:@"003"];
        });

        it(@"NSDateをISO8601のNSStringに変換できる", ^{
            MGDateTransformer *dateTransformer = [[MGDateTransformer alloc] init];
            dateTransformer.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:kTimeZoneName];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
            NSString *dateString = [dateTransformer reverseTransformedValue:date];
            [[dateString should] equal:@"1970-01-01T09:00:00.000+0900"];
        });

    });

SPEC_END