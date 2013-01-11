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

#import "AGCoreDataConfiguration.h"

@implementation AGCoreDataConfiguration

@synthesize managedObjectModel = _managedObjectModel;
@synthesize baseURL = _baseURL;
@synthesize authMod = _authMod;

@synthesize entityMapperInformation = _entityMapperInformation;

- (id)init {
    self = [super init];
    if (self) {
        _entityMapperInformation = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)applyEntityMappers:(AGEntityMapper *)firstObject, ... {
    va_list args;
    
    if (firstObject) {
        // add the first obj/info:
        [_entityMapperInformation setValue:firstObject.mapper forKey:firstObject.name];
        
        // loop over the rest of the objects:
        va_start(args, firstObject);
        AGEntityMapper *eachObject = nil;
        while ((eachObject = va_arg(args,AGEntityMapper*))) {
            // add the mapper, for each entity class:
            [_entityMapperInformation setValue:eachObject.mapper forKey:eachObject.name];
        }
        va_end(args);
    }
}

@end
