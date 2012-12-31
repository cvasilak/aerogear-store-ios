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

#import "AGTestStoreAdapter.h"
#import "AGAuthenticator.h"
#import "AGCoreDataHelper.h"

#import "Tag.h"

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

-(void) testAuthMod {
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
        
        
        AGCoreDataHelper *helper = [[AGCoreDataHelper alloc] initWithModel:managedObjectModel baseURL:baseURL authMod:myMod];
        
        NSManagedObjectContext *context = helper.managedObjectContext;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSLog(@"AAA");
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        NSLog(@"error: %@", error);
        
        NSLog(@"BBB -> %@", fetchedObjects);
//
        for (Tag *tag in fetchedObjects) {
            NSLog(@"\t\t%@ ", tag.title);
        }
        
        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.title = @"TASK";
        tag.style =@"tag-133-191-79";

        // Save everything
        NSError *error2 = nil;
        if ([context save:&error2]) {
            NSLog(@"The save was successful!");
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
