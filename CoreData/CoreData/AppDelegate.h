//
//  AppDelegate.h
//  CoreData
//
//  Created by chenchao on 16/3/15.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//被管理数据的上下文
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//可视化建模文件
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//持久化存储助理
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//将手机内存的数据持久化
- (void)saveContext;
//获取真实文件的路劲
- (NSURL *)applicationDocumentsDirectory;


@end

