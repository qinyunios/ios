//
//  ViewController.m
//  abc
//
//  Created by 云飞孙 on 2017/2/10.
//  Copyright © 2017年 云飞孙. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Student+CoreDataProperties.h"
#import "Student+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    //2、创建持久化助理
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"mySqlite.sqlite"];
    NSLog(@"path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    //设置数据库相关信息
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
    
    
    //3、创建上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    [context setPersistentStoreCoordinator:store];
    
    //增加数据
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    student.name = @"小米";
    student.age = 12;
    [context save:nil];
    
    //查询数据
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    Student *xiaoMi = result[0];
    NSLog(@"%@",xiaoMi.name);
    
    //修改数据
    xiaoMi.name = @"小妹";
    [context save:nil];
    
    result = [context executeFetchRequest:request error:nil];
    Student *xiaomei = result[0];
    NSLog(@"%@",xiaomei);
    NSLog(@"%@",xiaoMi);
    
    NSLog(@"%ld",result.count);
    //删除数据
    [context deleteObject:xiaomei];
    [context save:nil];
    
    
    NSLog(@"sdasdadadadsa");
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
