//
//  ViewController.m
//  CoreData
//
//  Created by ; on 16/3/15.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Person+CoreDataProperties.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//创建一个上下文对象 用于处理持久化相关的请求
@property (nonatomic,strong) NSManagedObjectContext *context;
//数据源
@property (nonatomic,strong) NSMutableArray *allData;


@end

@implementation ViewController
- (IBAction)addEntity:(id)sender {
    //2. 添加数据
    //创建实体描述
    NSEntityDescription *perDes = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    //实例实体
    Person *per = [[Person alloc] initWithEntity:perDes insertIntoManagedObjectContext:self.context];
    per.name = @"zhansgan ";
    per.age = [NSNumber numberWithInt:13];
    
    //更新数据源
    [self.allData addObject:per];
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:self.allData.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationLeft];
    NSError *error = nil;
    [self.context save:&error];
    
    if (nil != error) {
        NSLog(@"数据持久化有问题");
    }
    
    //更新上下文
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    [dele saveContext];
    NSLog(@"数据持久化无问题");

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 属性的初始化
    [self initData];
}

- (void)initData{
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    self.context = dele.managedObjectContext;
    
    self.allData = [NSMutableArray array];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
}


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *per = self.allData[indexPath.row];
    
    cell.textLabel.text = per.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",per.age];
    
    return cell;
}

@end
