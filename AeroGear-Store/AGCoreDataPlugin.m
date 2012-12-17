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

#import "AGCoreDataPlugin.h"

@implementation AGCoreDataPlugin {
    NSManagedObjectModel *_managedObjectModel;
    // TODO: perhaps the 'storeCoordinator' should be public:
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}


// core data, public hooks
@synthesize managedObjectContext = _managedObjectContext;

//static:
id<AGAuthenticationModule> _authenticationModule;
NSString *_modelName;
NSURL *_baseURL;

//FACTORY
+ (AGCoreDataPlugin *)sharedClient:(id<AGAuthenticationModule>) authenticationModule model:(NSString *) model baseURL:(NSURL *) baseURL {
    
    
    static AGCoreDataPlugin *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AGCoreDataPlugin alloc] init]; // iniot with.......
        _authenticationModule = authenticationModule;
        _modelName = model;
        _baseURL = baseURL;
    });
    
    return _sharedClient;
    
}
+ (AGCoreDataPlugin *)sharedClient {
    return [AGCoreDataPlugin sharedClient:nil model:nil baseURL:nil];
}

// getter from protocol:
-(id<AGAuthenticationModule>) authModule {
    return _authenticationModule;
}

-(NSURL *) baseURL {
    return _baseURL;
}

+(NSString *) modelName {
    return _modelName;
}

+(NSString *) extension {
    return @"momd";
}


//CORE DATA/ AFIncStore
//  An instance of NSManagedObjectContext represents a single “object space” or scratch pad in an application
- (NSManagedObjectContext *)managedObjectContext {
    // A
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    // get the LIB persStoreCoordinator:
    NSPersistentStoreCoordinator *coordinator = [self storeCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)storeCoordinator {
    // B
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //    Instances of NSPersistentStoreCoordinator associate persistent stores (by type) with a model (or more accurately, a configuration of a model) and serve to mediate between the persistent store or stores and the managed object context or contexts. Instances of NSManagedObjectContext use a coordinator to save object graphs to persistent storage and to retrieve model information.
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AGIncrementalStore *incrementalStore = (AGIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:
           [self type] configuration:nil URL:nil options:nil error:nil];
    
    
    NSError *error = nil;
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    // C
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //////////////// APP: Model Name:
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


@end
