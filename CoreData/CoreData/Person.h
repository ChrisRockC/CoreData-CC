//
//  Person.h
//  CoreData
//
//  Created by chenchao on 16/3/15.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END宏之间的简单指针都被定义为nonnull，因此我们只需要去指定那些nullable的指针。
NS_ASSUME_NONNULL_BEGIN

@interface Person : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Person+CoreDataProperties.h"
