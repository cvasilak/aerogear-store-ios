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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AGAuthenticationModule.h"
#import "AGCoreDataConfig.h"

/**
 * Helper class to setup the CoreData stack. Pass in a AGCoreDataConfig object and receive the
 * NSManagedObjectContext, that's all you need to access a remote endpoint, using the CoreData API.
 */
@interface AGCoreDataHelper : NSObject

/**
 * Returns configured 'NSManagedObjectContext', pointing to the given remote endpoint.
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 * An initializer method to instantiate the AGCoreDataHelper.
 *
 * @param config A block object which passes in an implementation of the AGCoreDataConfig protocol.
 * The object is used to configure the CoreData stack of the AGCoreDataHelper object.
 *
 * @return AGCoreDataHelper with a configured CoreData stack.
 */
-(id) initWithConfig:(void (^)(id<AGCoreDataConfig> config)) config;

@end
