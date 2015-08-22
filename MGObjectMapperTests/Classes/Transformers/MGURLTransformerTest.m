//
// Created by asaake on 15/08/21.
// Copyright (c) 2015 asaake. All rights reserved.
//

#import <Kiwi.h>
#import "MGURLTransformer.h"

SPEC_BEGIN(MGURLTransformerSpec)

    describe(@"MGURLTransformer", ^{

        it(@"NSStringをNSURLに変換できる", ^{
            MGURLTransformer *urlTransformer = [[MGURLTransformer alloc] init];
            NSURL *url = [urlTransformer transformedValue:@"http://localhost:8080"];
            [[url.absoluteString should] equal:@"http://localhost:8080"];
        });

        it(@"NSURLをNSStringに変換できる", ^{
            MGURLTransformer *urlTransformer = [[MGURLTransformer alloc] init];
            NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8080"];
            NSString *urlString = [urlTransformer reverseTransformedValue:url];
            [[urlString should] equal:url.absoluteString];
        });

    });

SPEC_END