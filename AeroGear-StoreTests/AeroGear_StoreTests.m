/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2012 Red Hat, Inc., and individual contributors
 * as indicated by the @author tags.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <SenTestingKit/SenTestingKit.h>

#import "AGIncrementalStore.h"
#import "AGIncrementalStoreHttpClient.h"

@interface AeroGear_StoreTests : SenTestCase

@end
@implementation AeroGear_StoreTests{
    BOOL _finishedFlag;
}


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


-(void) testModelExtension {
    @try {
        [AGIncrementalStore extension];
        STFail(@"should not get here...");
    }
    @catch (NSException *e) {
        // expected...
    }
    @finally {
        // nope..
    }
}

-(void) testModelName {
    @try {
        [AGIncrementalStore modelName];
        STFail(@"should not get here...");
    }
    @catch (NSException *e) {
        // expected...
    }
    @finally {
        // nope..
    }
}

-(void) testBaseURL {
    @try {
        AGIncrementalStore *store = [[AGIncrementalStore alloc] init];
        [store baseURL];
        STFail(@"should not get here...");
    }
    @catch (NSException *e) {
        // expected...
    }
    @finally {
        // nope..
    }
}

-(void) testIncHttpClient {
    
    NSURL* testURL = [NSURL URLWithString:@"http://todo-aerogear.rhcloud.com/todo-server/"];
    AGIncrementalStoreHttpClient* httpClient = [AGIncrementalStoreHttpClient clientFor:testURL authModule:nil];
    
    [httpClient getPath:@"tasks" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DA -> %@", responseObject);
        
        _finishedFlag = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error -> %@", error);
    }];
    
    
    // keep the run loop going
    while(!_finishedFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

@end
