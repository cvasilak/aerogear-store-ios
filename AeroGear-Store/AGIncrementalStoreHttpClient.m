/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
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
    NSDictionary *_mapperInformation;
}

+ (AGIncrementalStoreHttpClient *)clientFor:(NSURL *)baseURL  authModule:(id<AGAuthenticationModule>) authModule mapper:(NSDictionary *) mapper{
    return [[self alloc] initWithBaseURL:baseURL authModule:authModule mapper:mapper];
}

- (id)initWithBaseURL:(NSURL *)url authModule:(id<AGAuthenticationModule>) authModule mapper:(NSDictionary *) mapper{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    _authModule = (id<AGAuthenticationModuleAdapter>) authModule;
    _mapperInformation = mapper;

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
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

#pragma mark - AFIncrementalStoreHTTPClient

#pragma mark Read Methods (GET)
- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    // matching properties+values:
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];

    // does the given entity have a registered mapping ?
    if ([_mapperInformation objectForKey:entity.name]) {
        NSDictionary *mappingPerEntity = [_mapperInformation objectForKey:entity.name];
        
        // get all the properties for the managed object:
        NSMutableSet *propertyKeys = [NSMutableSet set];
        for (NSPropertyDescription *property in entity) {
            [propertyKeys addObject:property.name];
        }

        // apply the mapping from JSON rep. to Managed object:
        for (NSString *propertyKey in propertyKeys) {
            NSString *externalKeyPath = mappingPerEntity[propertyKey] ?: propertyKey;
		    id value = [representation valueForKeyPath:externalKeyPath];
		    if (value == nil) continue;
            [mutablePropertyValues setObject:value forKey:propertyKey];
        }
    }
    return mutablePropertyValues;
}


#pragma mark Write Methods (POST, PUT)
- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes
                             ofManagedObject:(NSManagedObject *)managedObject {
    
    // get the given managed bean as key/valye store (dictionary)
    NSDictionary *managedObjectRepresentation =  [[super representationOfAttributes:attributes ofManagedObject:managedObject] mutableCopy];
    
    // dictionary with key/value pairs, to be sent to the server
    NSMutableDictionary *externalRepresentation = [NSMutableDictionary dictionaryWithCapacity:managedObjectRepresentation.count];
    // does the given entity have a registered mapping ?
    if ([_mapperInformation objectForKey:managedObject.entity.name]) {
        NSDictionary *mappingPerEntity = [_mapperInformation objectForKey:managedObject.entity.name];
        
        // iterate over the key/value pairs of the MO, to fill the externalRepresentation with life...
        [managedObjectRepresentation enumerateKeysAndObjectsUsingBlock:^(NSString *propertyKey, id value, BOOL *stop) {
            NSString *externalKeyPath = mappingPerEntity[propertyKey] ?: propertyKey;
            NSArray *keyPathComponents = [externalKeyPath componentsSeparatedByString:@"."];
            
            if (![value isEqual:NSNull.null]) {
                // Set up intermediate key paths if the value we'd be setting isn't
                // nil.
                id obj = externalRepresentation;
                for (NSString *component in keyPathComponents) {
                    if ([obj valueForKey:component] == nil) {
                        // Insert an empty mutable dictionary at this spot so that we
                        // can set the whole key path afterward.
                        [obj setValue:[NSMutableDictionary dictionary] forKey:component];
                    }
                    
                    obj = [obj valueForKey:component];
                }
            }
            
            [externalRepresentation setValue:value forKeyPath:externalKeyPath];
        }];
    }
    return externalRepresentation;
}

@end
