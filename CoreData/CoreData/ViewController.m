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
   
    [self addDataToCoreData];
}

-(void)addDataToCoreData{
    //2. 添加数据
    //创建实体描述
    NSEntityDescription *perDes = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    //实例实体
    Person *per = [[Person alloc] initWithEntity:perDes insertIntoManagedObjectContext:self.context];
    per.name = @"zhansgan ";
    per.age = [NSNumber numberWithInt:arc4random()%10];
    
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

//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self getAllDataFromCoreData];
//}


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

//3. 查询数据
-(void)getAllDataFromCoreData{
    NSFetchRequest *fecthRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    [fecthRequest setEntity:des];
    //设置排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    [fecthRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
    NSError *error = nil;
    NSArray *fetchData = [self.context executeFetchRequest:fecthRequest error:&error];
    if (fetchData == nil) {
        NSLog(@"数据库无数据");
    }
    //刷新数据
    [self.allData addObjectsFromArray:fetchData];
    [self.tableView reloadData];
    
}

//4. 点击cell改变数据   fetch直接可以联想一大块代码 非常好用 方便记忆
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //4.1 查询当前是哪行数据
    NSFetchRequest *fetch = [[ NSFetchRequest alloc] init]; //抓取请求
    
    NSEntityDescription *des = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    [fetch setEntity:des];  //对哪一个实体做操作
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES]; //抓取的结果排序
    [fetch setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
    
    NSError *error = nil;
    NSArray *fetchData = [self.context executeFetchRequest:fetch error:&error];
    
    //4.2 创建新的数据
    Person *person = self.allData[indexPath.row];
    person.name = @"赵四";
    person.age = [NSNumber numberWithInt:1000];
    
    
   
    //4.3 刷新数据源 更换数据
    [self.allData removeAllObjects];
    [self.allData addObjectsFromArray:fetchData];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //4.4 修改本地化
    [self.context save:nil];
    
}

//5.侧滑删除数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //5.1 获取当前数据
    Person *person = self.allData[indexPath.row];
    //5.2 本地数据源删除  刷新UI
    [self.allData removeObject:person];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    //5.3 数据库删除
    [self.context deleteObject:person];
    [self.context save:nil];
}




@end
