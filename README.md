# RuntimeTool

[![CI Status](http://img.shields.io/travis/guodongyangw@163.com/RuntimeTool.svg?style=flat)](https://travis-ci.org/guodongyangw@163.com/RuntimeTool)
[![Version](https://img.shields.io/cocoapods/v/RuntimeTool.svg?style=flat)](http://cocoapods.org/pods/RuntimeTool)
[![License](https://img.shields.io/cocoapods/l/RuntimeTool.svg?style=flat)](http://cocoapods.org/pods/RuntimeTool)
[![Platform](https://img.shields.io/cocoapods/p/RuntimeTool.svg?style=flat)](http://cocoapods.org/pods/RuntimeTool)

RuntimeTool是一个帮你轻松使用runtime的工具集。
##功能：

* 获取类所有的变量列表
* 获取类所有的属性列表
* 获取类所有的方法列表
* 通过NSInvocation调用方法
* 运行时动态创建类
* 运行时动态创建方法
* 关联对象（关联，获取，删除）
* 方法替换
* 设置私有变量

## Installation
RuntimeTool支持多种安装方法

###installation with CocoaPods
RuntimeTool is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RuntimeTool",'~>1.0'
```

然后，运行下面的命令：

```
pod install
```


##Usage

####获取所有变量列表

```
    [RuntimeTool getVarsForClassName:@"UIView"];
    [RuntimeTool getVarsForClass:[UIView class]];
```

####获取所有的属性列表

```
    [RuntimeTool getPropertiesForClass:[UIView class]];
    [RuntimeTool getPropertiesForClassName:@"UIView"];
```

####获取所有的方法列表

```
    [RuntimeTool getMethodsForClass:[UIView class]];
    [RuntimeTool getMethodsForClassName:@"UIView"];
```

####通过NSInvocation调用方法

```
    TestClass * test = [TestClass new];
    id returnValue = [RuntimeTool invokeMethod:test method:@selector(setNum:height:name:) argumentValue:@(10), nil];
```

####运行时动态创建类

```
    Class class = [RuntimeTool createClassOnRuntime:@"MyButton" superClass:@"UIButton"];
```

####运行时动态创建方法

```
    NSString* className = @"MyButton";
    NSString* methodStr = @"printLog";
    Class newClass = [RuntimeTool createClassOnRuntime:className superClass:@"UIButton"];
    [RuntimeTool createMethodForClass:className methodStr:methodStr imp:(IMP)printLog];
    id instance = [[newClass alloc]init];
    [instance performSelector:NSSelectorFromString(methodStr) withObject:nil];
    
    //方法的实现
    void printLog(id self,SEL _cmd) {
    printf("hello,world");
}
```

####关联对象

```
    //给当前controller关联一个color对象
    NSString* key = @"colorKey";
    [RuntimeTool createAssociatedObject:self key:key value:[UIColor yellowColor] policy:OBJC_ASSOCIATION_RETAIN];
    //获取color对象并设置背景色
    UIColor* color = (UIColor*)[RuntimeTool getAssociatedObjectValue:self key:key];
    self.view.backgroundColor = color;
    //删除关联对象
    [RuntimeTool removeAssociatedObjec:self];
    [self performSelector:@selector(clearColor) withObject:nil afterDelay:2];
```

####方法替换

```
- (void)test1 {
    NSLog(@"test1");
}

- (void)test2 {
    NSLog(@"test2");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"hello,wrold");
}

- (void)swizzle_viewWillAppear:(BOOL)animated{
    NSLog(@"world,hello");
}


//方式1（两个方法相互替换实现）：
[self test1];
[RuntimeTool methodExchange:[self class] sel1:@selector(test1) sel2:@selector(test2)];
[self test2];
//输出结果都是  test1

//方式2（替换某个方法的实现）：
[self viewWillAppear:NO];
[RuntimeTool swizzleMethodImp:[self class] sel:@selector(viewWillAppear:) imp:method_getImplementation(class_getInstanceMethod([self class], @selector(swizzle_viewWillAppear:)))];
[self viewWillAppear:NO];

//输出结果  hello,world    world,hello

```

####设置私有变量

```
    TestClass * test = [TestClass new];
    test.num = @(100);
    NSLog(@"alter before: %@",test.num);
    [RuntimeTool setVarForObj:test key:@"_num" value:@(100000)];
    NSLog(@"alter after: %@",test.num);
```

## Author

guodongyangw@163.com, guodongyang@qfpay.com

## License

RuntimeTool is available under the MIT license. See the LICENSE file for more info.


