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

/**
 * Mapper object for a NSEntityDescription object. The entity is identified by name and the mapper has a NSDictionary, which
 * provides mapping information so that a managed object can be created from an external response, like a JSON response.
 */
@interface AGEntityMapper : NSObject

/**
 * Returns the name of the entity
 */
@property (readonly, strong, nonatomic) NSString *name;

/**
 * Returns a NSDictionary, representing the mapping between the external representation (e.g. JSON) and the properties on the managed object.
 */
@property (readonly, strong, nonatomic) NSDictionary *mapper;

/**
 * Creates an entity mapper object for a NSEntityDescription object, identified by name. The entity mapper object also contains
 * mapping information that is needed in order to create a managed object out of an external representation (e.g. JSON) and vice versa.
 *
 * @param entityName The name of the entity.
 *
 * @param mapper NSDictionary representing the mapping between the external representation (e.g. JSON) and the properties on the managed object.
 *
 * @return entity mapper object
 */
-(id) initForEntity:(NSString *) entityName mapper:(NSDictionary *) mapper;

@end
