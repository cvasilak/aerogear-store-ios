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

#import "AGAuthenticator.h"
#import "AGCoreDataHelper.h"
#import "AGEntityMapper.h"

#import "Tag.h"
#import "Project.h"
#import "Task.h"

@interface AGCustomStoreAdapterTests : SenTestCase

@end

@implementation AGCustomStoreAdapterTests{
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

-(void) test_FetchTasks {
    // create an authenticator object
    AGAuthenticator* authenticator = [AGAuthenticator authenticator];
    
    // add a new auth module and the required 'base url':
    NSURL* baseURL = [NSURL URLWithString:@"https://todoauth-aerogear.rhcloud.com/todo-server/"];
    id<AGAuthenticationModule> myMod = [authenticator auth:^(id<AGAuthConfig> config) {
        [config name:@"authMod"];
        [config baseURL:baseURL];
    }];
    
    
    [myMod login:@"john" password:@"123" success:^(id object) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"TestModel" withExtension:@"momd"];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];

        
        AGEntityMapper *taskMapper =
        [[AGEntityMapper alloc] initWithName:@"Task"
         // mapping the properties on the "entity" (NSManagedObject)
         // to the external representation (e.g. JSON)
                                   mapper:@{ @"desc": @"description", @"myId": @"id"}];
        
        AGEntityMapper *projectMapper =
        [[AGEntityMapper alloc] initWithName:@"Project"
         // mapping the properties on the "entity" (NSManagedObject)
         // to the external representation (e.g. JSON)
                                   mapper:@{ @"myId": @"id"}];
        
        AGCoreDataHelper *helper = [[AGCoreDataHelper alloc] initWithConfig:^(id<AGCoreDataConfig> config) {
            [config setManagedObjectModel:managedObjectModel];
            [config setBaseURL:baseURL];
            [config setAuthMod:myMod];
            
            [config applyEntityMappers:taskMapper, projectMapper, nil];
            
        }];
        
        NSManagedObjectContext *context = helper.managedObjectContext;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"AFIncrementalStoreContextDidFetchRemoteValues" object:context queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *userInfo = [note userInfo];
            NSArray *fetchedObjects = [userInfo objectForKey:@"AFIncrementalStoreFetchedObjectsKey"];
            
            for(Task *task in fetchedObjects) {
                NSLog(@"\n\ntit;e: %@; desc: %@", task.title, task.desc);
            }
            
            
            _finishedFlag = YES;
            
        }];
        
        [context executeFetchRequest:fetchRequest error:&error];
    } failure:^(NSError *error) {
        //
    }];
    
    // keep the run loop going
    while(!_finishedFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}
-(void) testSaveTask {
    // create an authenticator object
    AGAuthenticator* authenticator = [AGAuthenticator authenticator];
    
    // add a new auth module and the required 'base url':
    NSURL* baseURL = [NSURL URLWithString:@"https://todoauth-aerogear.rhcloud.com/todo-server/"];
    id<AGAuthenticationModule> myMod = [authenticator auth:^(id<AGAuthConfig> config) {
        [config name:@"authMod"];
        [config baseURL:baseURL];
    }];
    
    
    [myMod login:@"john" password:@"123" success:^(id object) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"TestModel" withExtension:@"momd"];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
        AGEntityMapper *taskMapper =
        [[AGEntityMapper alloc] initWithName:@"Task"
         // mapping the properties on the "entity" (NSManagedObject)
         // to the external representation (e.g. JSON)
                                      mapper:@{ @"desc": @"description", @"myId": @"id"}];
        
        AGEntityMapper *projectMapper =
        [[AGEntityMapper alloc] initWithName:@"Project"
         // mapping the properties on the "entity" (NSManagedObject)
         // to the external representation (e.g. JSON)
                                      mapper:@{ @"myId": @"id"}];

        AGCoreDataHelper *helper = [[AGCoreDataHelper alloc] initWithConfig:^(id<AGCoreDataConfig> config) {
            [config setManagedObjectModel:managedObjectModel];
            [config setBaseURL:baseURL];
            [config setAuthMod:myMod];

            [config applyEntityMappers:taskMapper, projectMapper, nil];
        }];
        
        NSManagedObjectContext *context = helper.managedObjectContext;
        
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        task.title = @"MEH ...... Core Data";
        task.desc = @"Some Core Data playings..";
        
        // Save everything (causes a HTTP POST, against the AG backend)
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"The save was successful!");
            _finishedFlag =YES;
        } else {
            NSLog(@"The save wasn't successful: %@", [error userInfo]);
        }
        
    } failure:^(NSError *error) {
        //
    }];
    
    // keep the run loop going
    while(!_finishedFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}



-(void) xtest_FetchWithAuthMod {
    // create an authenticator object
    AGAuthenticator* authenticator = [AGAuthenticator authenticator];
    
    // add a new auth module and the required 'base url':
    NSURL* baseURL = [NSURL URLWithString:@"https://todoauth-aerogear.rhcloud.com/todo-server/"];
    id<AGAuthenticationModule> myMod = [authenticator auth:^(id<AGAuthConfig> config) {
        [config name:@"authMod"];
        [config baseURL:baseURL];
    }];
    
    
    [myMod login:@"john" password:@"123" success:^(id object) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"TestModel" withExtension:@"momd"];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
        
        AGCoreDataHelper *helper = [[AGCoreDataHelper alloc] initWithConfig:^(id<AGCoreDataConfig> config) {
            [config setManagedObjectModel:managedObjectModel];
            [config setBaseURL:baseURL];
            [config setAuthMod:myMod];
        }];
        
        NSManagedObjectContext *context = helper.managedObjectContext;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;

        [[NSNotificationCenter defaultCenter] addObserverForName:@"AFIncrementalStoreContextDidFetchRemoteValues" object:context queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *userInfo = [note userInfo];
            NSArray *fetchedObjects = [userInfo objectForKey:@"AFIncrementalStoreFetchedObjectsKey"];
            
            for(Tag *tag in fetchedObjects) {
                NSLog(@"\n\nID: %@; title: %@", tag.title, tag.title);
            }


            _finishedFlag = YES;
            
        }];
        
        [context executeFetchRequest:fetchRequest error:&error];
    } failure:^(NSError *error) {
        //
    }];
    
    // keep the run loop going
    while(!_finishedFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}
-(void) xtestSaveWithAuthMod {
    // create an authenticator object
    AGAuthenticator* authenticator = [AGAuthenticator authenticator];
    
    // add a new auth module and the required 'base url':
    NSURL* baseURL = [NSURL URLWithString:@"https://todoauth-aerogear.rhcloud.com/todo-server/"];
    id<AGAuthenticationModule> myMod = [authenticator auth:^(id<AGAuthConfig> config) {
        [config name:@"authMod"];
        [config baseURL:baseURL];
    }];
    
    
    [myMod login:@"john" password:@"123" success:^(id object) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"TestModel" withExtension:@"momd"];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
        
        AGCoreDataHelper *helper = [[AGCoreDataHelper alloc] initWithConfig:^(id<AGCoreDataConfig> config) {
            [config setManagedObjectModel:managedObjectModel];
            [config setBaseURL:baseURL];
            [config setAuthMod:myMod];
        }];
        
        NSManagedObjectContext *context = helper.managedObjectContext;
        
        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.title = @"Unit Test Tag";
        tag.style =@"tag-133-191-79";

        // Save everything
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"The save was successful!");
            _finishedFlag =YES;
        } else {
            NSLog(@"The save wasn't successful: %@", [error userInfo]);
        }
        
        
        //_finishedFlag = YES;
    } failure:^(NSError *error) {
        //
    }];
    
    // keep the run loop going
    while(!_finishedFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}

//-(void) testModelExtension {
//    [AGTestStoreAdapter extension];
//}
//
//-(void) testModelName {
//    [AGTestStoreAdapter modelName];
//}
//
//-(void) testBaseURL {
//    AGTestStoreAdapter *store = [[AGTestStoreAdapter alloc] init];
//    [store baseURL];
//}

@end
