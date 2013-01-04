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

#import "AGCoreDataHelper.h"
#import "AGIncrementalStore.h"
#import "AGCoreDataConfiguration.h"

@interface AGCoreDataHelper ()

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSURL *baseURL;
@property (readonly, strong, nonatomic) id<AGAuthenticationModule> authMod;

@end

@implementation AGCoreDataHelper

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize baseURL = _baseURL;
@synthesize authMod = _authMod;


//-(id)init {
//    // throw NSException that this is not the designated initializer..
//}

-(id) initWithConfig:(void (^)(id<AGCoreDataConfig> config)) config {
    self = [super init];
    if (self) {
        AGCoreDataConfiguration *coreDataConfig = [[AGCoreDataConfiguration alloc] init];
    
        if (config) {
            config(coreDataConfig);
        }
        _managedObjectModel = coreDataConfig.managedObjectModel;
        _baseURL = coreDataConfig.baseURL;
        _authMod = coreDataConfig.authMod;
        
        // awful setters:
        [AGIncrementalStore setModel:_managedObjectModel];
        [AGIncrementalStore setBaseURL:_baseURL];
        [AGIncrementalStore setAuthModule:_authMod];
        [AGIncrementalStore setEntityMapper:coreDataConfig.entityMapperInformation];
    }
    return self;
}




/// CoreData hocks... like in App Delegate..
- (NSManagedObjectContext *)managedObjectContext {
    // A
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    // get the LIB persStoreCoordinator:
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AGIncrementalStore *incrementalStore = (AGIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:
                                                                  [AGIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
    
    
    NSError *error = nil;
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



@end
