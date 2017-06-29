//
//  RuntimeTool.h
//  testHook
//
//  Created by gdy on 2017/6/28.
//  Copyright © 2017年 gdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RuntimeTool : NSObject

#pragma mark - 获取方法、变量、属性列表
/*
    获取类的所有变量
 
    @param className  类名
    @return 返回类的所有变量名称数组
 */
+ (NSArray*)getVarsForClassName:(NSString*)className;
+ (NSArray*)getVarsForClass:(Class)cla;

/*
 获取类的所有属性
 
 @param className  类名
 @return 返回类的所有属性名称数组
 */
+ (NSArray*)getPropertiesForClassName:(NSString*)className;
+ (NSArray*)getPropertiesForClass:(Class)cla;

/*
 获取类的方法列表(包括分类)
    
 @param className   类名
 @return 返回类的方法列表
 */
+ (NSArray*)getMethodsForClassName:(NSString*)className;
+ (NSArray*)getMethodsForClass:(Class)cla;

#pragma mark - 实例方法调用

/*
    调用对象的方法
 
    @param  obj         对象
    @param  method      方法
    @param  value       可变长参数
    @return 返回方法的返回值
 */
+ (id)invokeMethod:(id)obj method:(SEL)method argumentValue:(id)value,...NS_REQUIRES_NIL_TERMINATION; 


#pragma mark - 运行时创建类、方法

+ (Class)createClassOnRuntime:(NSString*)className superClass:(NSString*)superClass;

+ (void)createMethodForClass:(NSString*)className methodStr:(NSString*)methodStr imp:(IMP)imp;

#pragma mark - 关联
//关联（使其中的一个对象作为另一个对象的一部分）
/*
 设置、获取、删除关联对象
 
 @param     obj         源对象
 @param     key         关联对象对应的key
 @param     value       关联对象对应的value
 @param     policy      关联策略（copy，retain，assign等）
 
 @return    获取关联的对象的值
 */

+ (void)createAssociatedObject:(id)obj key:(NSString*)key value:(id)value policy:(objc_AssociationPolicy)policy;

+ (id)getAssociatedObjectValue:(id)obj key:(NSString*)key;

+ (void)removeAssociatedObjec:(id)obj;


#pragma mark - 方法实现替换
/*
 实现两个方法实现的替换
 
 @param     cla     类
 @param     sel1    方法1
 @param     sel2    方法2
 */
+ (void)methodExchange:(Class)cla sel1:(SEL)sel1 sel2:(SEL)sel2;

/*
    替换一个方法的实现
 
    @param  cla         类
    @param  origSel     需要替换方法实现的方法
    @param  newIMP      新的方法实现
 */
+ (void)swizzleMethodImp:(Class)cla sel:(SEL)origSel imp:(IMP)newIMP;

#pragma mark - 修改私有变量
/*
 设置私有变量的值

 @param     obj     对象
 @param     key     私有变量对应的key
 @param     value   值
 */
+ (void)setVarForObj:(id)obj key:(NSString*)key value:(id)value;

@end
