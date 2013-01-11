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

#import <Foundation/Foundation.h>
#import <CoreData/NSManagedObjectModel.h>

#import "AGAuthenticationModule.h"
#import "AGEntityMapper.h"

/**
 * Represents the public API to configure the AGCoreDataHelper.
 */
@protocol AGCoreDataConfig <NSObject>

/**
 * Applies a CoreData model object to the configuration.
 */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/**
 * Applies the baseURL to the configuration.
 */
@property (strong, nonatomic) NSURL *baseURL;

/**
 * Applies the AGAuthenticationModule object to the configuration.
 */
@property (strong, nonatomic) id<AGAuthenticationModule> authMod;

/**
 * Applies the the specified set of AGEntityMapper objects to the configuration.
 */
-(void)applyEntityMappers:(AGEntityMapper *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end
