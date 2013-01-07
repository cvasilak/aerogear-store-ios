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

#import "AGIncrementalStore.h"
#import "AGIncrementalStoreHttpClient.h"

@implementation AGIncrementalStore

#pragma mark - AFIncrementalStore.h

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

#pragma mark AFIncrementalStore
- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    
    return [AGIncrementalStoreHttpClient clientFor:__baseURL authModule:__authMod mapper:__mapper];
}

#pragma mark Global Setters
NSDictionary *__mapper;
+(void) setEntityMapper:(NSDictionary *) mapper {
    __mapper = mapper;
}

NSURL *__baseURL;
+(void) setBaseURL:(NSURL *) baseURL {
    __baseURL = baseURL;
}

id<AGAuthenticationModule> __authMod;
+(void) setAuthModule:(id<AGAuthenticationModule>) authMod {
    __authMod = authMod;
}

-(id<AGAuthenticationModule>) authModule {
    return __authMod;
}

NSManagedObjectModel *__managedObjectModel;
+(void)setModel:(NSManagedObjectModel *)managedObjectModel {
    __managedObjectModel = managedObjectModel;
}

// according to the AFIncStore, this is required, but the function is never invoked.....
+ (NSManagedObjectModel *)model {
    return __managedObjectModel;
}



@end
