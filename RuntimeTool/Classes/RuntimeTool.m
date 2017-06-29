//
//  RuntimeTool.m
//  testHook
//
//  Created by gdy on 2017/6/28.
//  Copyright © 2017年 gdy. All rights reserved.
//

#import "RuntimeTool.h"
#import <UIKit/UIKit.h>


@implementation RuntimeTool

/*
 对类型进行转换
 
 @param type 运行时获取的类型
 @return 返回转换后的类型字符串
 */
+ (NSString*)encodeType:(const char*)type {
    if (strcmp(type, "@") == 0) {
        return @"id";
    }
    else if (strcmp(type, "#") == 0){
        return @"Class";
    }
    else if (strcmp(type, ":") == 0) {
        return @"SEL";
    }
    else if (strcmp(type, "c") == 0) {
        return @"char";
    }
    else if (strcmp(type, "C") == 0) {
        return @"unsigned char";
    }
    else if (strcmp(type, "s") == 0) {
        return @"sht";
    }
    else if (strcmp(type, "S") == 0) {
        return @"unsigned sht";
    }
    else if (strcmp(type, "i") == 0) {
        return @"int";
    }
    else if (strcmp(type, "I") == 0) {
        return @"unsigned int";
    }
    else if (strcmp(type, "l") == 0) {
        return @"long";
    }
    else if (strcmp(type, "L") == 0) {
        return @"unsigned long";
    }
    else if (strcmp(type, "q") == 0) {
        return @"long long";
    }
    else if (strcmp(type, "Q") == 0) {
        return @"unsigned long long";
    }
    else if (strcmp(type, "f") == 0) {
        return @"float";
    }
    else if (strcmp(type, "d") == 0) {
        return @"double";
    }
    else if (strcmp(type, "b") == 0) {
        return @"c_bfld";
    }
    else if (strcmp(type, "B") == 0) {
        return @"BOOL";
    }
    else if (strcmp(type, "V") == 0) {
        return @"void";
    }
    else if (strcmp(type, "?") == 0) {
        return @"undefiend";
    }
    else if (strcmp(type, "^") == 0) {
        return @"pointer";
    }
    else if (strcmp(type, "*") == 0) {
        return @"char pointer";
    }
    else if (strcmp(type, "%") == 0) {
        return @"atom";
    }
    else if (strcmp(type, "[") == 0) {
        return @"c_ary_b";
    }
    else if (strcmp(type, "]") == 0) {
        return @"c_ary_E";
    }
    else if (strcmp(type, "(") == 0) {
        return @"c_union_B";
    }
    else if (strcmp(type, ")") == 0) {
        return @"c_union_E";
    }
    else if (strcmp(type, "{") == 0) {
        return @"c_struct_B";
    }
    else if (strcmp(type, "}") == 0) {
        return @"c_struct_E";
    }
    else if (strcmp(type, "!") == 0) {
        return @"c_vector";
    }
    else if (strcmp(type, "r") == 0) {
        return @"const";
    }
    else{
        return [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
    }
}

+ (NSString*)encodeMethodType:(const char*)type{
    if (strcmp(type, @encode(void)) == 0) {
        return @"Void";
    }
    else{
        return [self encodeType:type];
    }
}

+ (NSArray*)getVarsForClassName:(NSString*)className {
    return [self getVarsForClass:NSClassFromString(className)];
}

+ (NSArray*)getVarsForClass:(Class)cla {
    NSMutableArray* varNameArr = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList(cla, &count);
    for (int i=0; i<count; i++) {
        Ivar var = vars[i];
        const char* varName = ivar_getName(var);
        const char* varType = ivar_getTypeEncoding(var);
        [varNameArr addObject:[NSString stringWithFormat:@"%s : %@",varName,[self encodeType:varType]]];
    }
    return varNameArr;
}

+ (NSArray*)getPropertiesForClassName:(NSString*)className {
    return [self getPropertiesForClass:NSClassFromString(className)];
}

+ (NSArray*)getPropertiesForClass:(Class)cla {
    NSMutableArray* propertyNameArr = [NSMutableArray array];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(cla, &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString* strAttr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSArray* strArr = [strAttr componentsSeparatedByString:@","];
        NSString* type = [((NSString*)strArr[0]) substringFromIndex:1];
        [propertyNameArr addObject:[NSString stringWithFormat:@"%s:%@",propertyName,[self encodeType:[type cStringUsingEncoding:NSUTF8StringEncoding]]]];
    }
    return propertyNameArr;
}

+ (NSArray*)getMethodsForClassName:(NSString*)className {
    return [self getMethodsForClass:NSClassFromString(className)];
}

+ (NSArray*)getMethodsForClass:(Class)cla {
    NSMutableArray * methodArr = [NSMutableArray array];
    unsigned int count = 0;
    Method* methods = class_copyMethodList(cla, &count);
    for (int i=0; i<count; i++) {
        Method method = methods[i];
        SEL methodNameSel = method_getName(method);
        //method name string
        NSString* methodName = [NSString stringWithCString:sel_getName(methodNameSel) encoding:NSUTF8StringEncoding];
        //return type
        const char *methodReturnType = method_copyReturnType(method);
        
        unsigned int argCount = method_getNumberOfArguments(method);
        NSString* mulStr = [NSString string];
        for (unsigned int i=0; i<argCount; i++) {
            char* argType = method_copyArgumentType(method, i);
            if (i == argCount - 1) {
                mulStr = [mulStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self encodeType:argType]]];
            }
            else{
                mulStr = [mulStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[self encodeType:argType]]];
            }
            
        }
        NSString* strLog = [NSString stringWithFormat:@"\n=====================================\nmethodName:%@\nmethodArgs:%@\nmethodReturnType:%@\n=====================================",methodName,mulStr,[self encodeMethodType:methodReturnType]];
        NSLog(@"%@",strLog);
        [methodArr addObject:strLog];
    }
    return methodArr;
}

+ (id)invokeMethod:(id)obj method:(SEL)method argumentValue:(id)value,...NS_REQUIRES_NIL_TERMINATION; {
    
    if  (obj == nil){
        [NSException raise:@"方法调用异常" format:@"对象不能为空",nil];
        return nil;
    }
    
    Class class = [obj class];
    //创建一个方法签名：（保存了方法的名称、参数、返回值)
    NSMethodSignature* methodSig = [class instanceMethodSignatureForSelector:method];
    if (methodSig == nil) {//调用的方法不存在
        NSString* info = [NSString stringWithFormat:@"%@方法找不到",NSStringFromSelector(method)];
        [NSException raise:@"方法调用异常" format:info,nil];
        return nil;
    }
    //创建一个NSInvocation对象
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    //设置执行对象
    [invocation setTarget:obj];
    //执行方法
    [invocation setSelector:method];
    //传入参数，index从2开始，因为0和1已经被占用了，分别是self（target）和selector（_cmd)
    
    //获取传入参数
    va_list values;
    va_start(values, value);
    NSMutableArray* valueArr = [NSMutableArray arrayWithObject:value];
    
    
    if(value)
    {
        NSString *nextArg;
        while((nextArg = va_arg(values, NSString *)))
        {
            NSLog(@"ARG :%@", nextArg);
            [valueArr addObject:nextArg];
        }
    }
    va_end(values);
    
    //获取方法 的参数个数
    NSUInteger argsCount = methodSig.numberOfArguments - 2;
    //获取传入的参数个数
    NSUInteger arrCount = valueArr.count;
    NSUInteger count = MIN(argsCount, arrCount);
    for (int i=0;i<count;i++){
        id obj = valueArr[i];
        if ([obj isKindOfClass:[NSNull class]]){
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i + 2];
    }
    
    [invocation invoke];
    void *returnValue;
    if (methodSig.methodReturnLength != 0){
        [invocation getReturnValue:&returnValue];
        return (__bridge id)returnValue;
    }
    else{
        return nil;
    }
}

+ (Class)createClassOnRuntime:(NSString*)className superClass:(NSString*)superClass {
    if ((className != nil && className.length > 0) && (superClass != nil && superClass.length > 0)) {
        Class newClass = objc_allocateClassPair(NSClassFromString(superClass), [className cStringUsingEncoding:NSUTF8StringEncoding], 0);
        objc_registerClassPair(newClass);
        return newClass;
    }
    else{
        [NSException raise:@"方法调用异常" format:@"类名或者父类名不能为空",nil];
    }
    return nil;
}

+ (void)createMethodForClass:(NSString*)className methodStr:(NSString*)methodStr imp:(IMP)imp {
    Class class = NSClassFromString(className);
    class_addMethod(class, NSSelectorFromString(methodStr), imp, "v@:");//"v@:":表示返回类型
}

+ (void)createAssociatedObject:(id)obj key:(NSString*)key value:(id)value policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(obj, [key cStringUsingEncoding:NSUTF8StringEncoding], value, policy);
}

+ (id)getAssociatedObjectValue:(id)obj key:(NSString*)key {
    return objc_getAssociatedObject(obj, [key cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (void)removeAssociatedObjec:(id)obj {
    objc_removeAssociatedObjects(obj);
}

+ (void)methodExchange:(Class)cla sel1:(SEL)sel1 sel2:(SEL)sel2 {
    if (sel1 == nil || sel2 == nil) {
        [NSException raise:@"方法调用异常" format:@"替换的方法不能为空",nil];
        return;
    }
    Method method1 = class_getInstanceMethod(cla, sel1);
    Method method2 = class_getInstanceMethod(cla, sel2);
    
    if (method1 == nil || method2 == nil) {
        [NSException raise:@"方法调用异常" format:@"替换的方法必须实现",nil];
        return;
    }
    
    method_exchangeImplementations(method1, method2);
}

+ (void)swizzleMethodImp:(Class)cla sel:(SEL)origSel imp:(IMP)newIMP {
    Method origMethod = class_getInstanceMethod(cla, origSel);
    //如果没有方法实现，直接把新的方法实现添加给方法
    if (!class_addMethod(cla, origSel, newIMP, method_getTypeEncoding(origMethod))) {
        //如果添加失败，证明已经有方法实现，那么设置为新的方法实现
        method_setImplementation(origMethod, newIMP);
    }
}

+ (void)setVarForObj:(id)obj key:(NSString*)key value:(id)value {
    unsigned int outCountMember = 0;
    Ivar *members = class_copyIvarList([obj class], &outCountMember);
    for (int i = 0; i<outCountMember; i++) {
        Ivar var = members[i];
        const char * memberName = ivar_getName(var);
        if ([[NSString stringWithFormat:@"%s",memberName] isEqualToString:key]) {
            Ivar m_member = var;
            object_setIvar(obj, m_member, value);
        }
    }
}



@end
