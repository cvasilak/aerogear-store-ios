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

#import "AGIncrementalStoreHttpClient.h"

#import "AGAuthenticationModuleAdapter.h"

@implementation AGIncrementalStoreHttpClient {
     id<AGAuthenticationModuleAdapter> _authModule;
}

+ (AGIncrementalStoreHttpClient *)clientFor:(NSURL *)baseURL  authModule:(id<AGAuthenticationModule>) authModule{
    return [[self alloc] initWithBaseURL:baseURL authModule:authModule];
}

- (id)initWithBaseURL:(NSURL *)url authModule:(id<AGAuthenticationModule>) authModule {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    _authModule = (id<AGAuthenticationModuleAdapter>) authModule;

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


// override from AFNetworking to apply auth:
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    // try to add auth.token:
    [self applyAuthToken];
    
    
    // invoke the 'requestWithMethod:path:parameters:' from AFNetworking:
    NSMutableURLRequest* req = [super requestWithMethod:method path:path parameters:parameters];
    
    // disable the default cookie handling in the override:
    [req setHTTPShouldHandleCookies:NO];
    
    
    return req;
}


-(void) applyAuthToken {
    if ([_authModule isAuthenticated]) {
        [self setDefaultHeader:@"Auth-Token" value:[_authModule authToken]];
    }
}

@end
