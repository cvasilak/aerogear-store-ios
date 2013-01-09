//
//  Tag.h
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 1/9/13.
//  Copyright (c) 2013 Matthias Wessendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * style;
@property (nonatomic, retain) NSString * title;

@end
