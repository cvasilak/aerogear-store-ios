//
//  Tag.h
//  AeroGear-Store
//
//  Created by Matthias Wessendorf on 12/30/12.
//  Copyright (c) 2012 Matthias Wessendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * style;

@end
