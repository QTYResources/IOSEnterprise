SharedInstance

通过单例实现ViewController之间的传值

（1）单例的创建
    创建一个新文件（类），以NSObject为基类。将这个类命名为MySharedInstance，对应的.h文件为MySharedInstance.h。
	@interface MySharedInstance : NSObject
	// 单例中的属性变量
	@property (nonatomic, strong) NSString *stringPassed;
	// 单例k类方法，称之为构造方法
	+ (MySharedInstance *)sharedInstance;
	@end
        在对应的.m实现文件MySharedInstance.m中，主要是实现“+ (MySharedInstance *)sharedInstance”方法。
	@implementation MySharedInstance
	
	+ (MySharedInstance *)sharedInstance {
	    // 声明一个f静态变量，确保单例类的实例在整个App中只有一个，而且是唯一的
	    static MySharedInstance *_sharedInstance = nil;
	    // 声明一个静态变量，确保这个类的实例创建过程只创建一次
	    static dispatch_once_t onceToken;
	    // 通过Grand Central Dispatch (GCD)，执行一个Block，用来初始化单例类的实例
	    dispatch_once(&onceToken, ^{
	        _sharedInstance = [[MySharedInstance alloc] init];
	    });
	    return _sharedInstance;
	}
	
    @end

（2）单例的初始化
    既然Singleton是一个全局变量，全局变量应该有个初始化的方法，这个方法就是“- (instancetype)init”。当执行“[[MySharedInstance alloc] init]”时，MySharedInstance中的属性变量stringPassed被赋初始化值。在MySharedInstance.m文件中，添加以下代码。
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	        self.stringPassed = @"Singleton initial Value";
	    }
	    return self;
	}
        还有一种初始化方式，就是在调用init时给出初始化值，而不是在init方法内初始化。就Singleton来说，因为初始化在整个App中只发生一次，放在init内部或外部，没有什么区别。不过，我们还是了解一下为好。在MySharedInstance.m文件中，添加以下代码。
	+ (MySharedInstance *)sharedInstance {
	    // 声明一个f静态变量，确保单例类的实例在整个App中只有一个，而且是唯一的
	    static MySharedInstance *_sharedInstance = nil;
	    // 声明一个静态变量，确保这个类的实例创建过程只创建一次
	    static dispatch_once_t onceToken;
	    // 通过Grand Central Dispatch (GCD)，执行一个Block，用来初始化单例类的实例
	    dispatch_once(&onceToken, ^{
	        _sharedInstance = [[MySharedInstance alloc] initWithValue:@"Singleton initial Value2"];
	    });
	    return _sharedInstance;
	}
	
	- (instancetype)initWithValue:(NSString *)str {
	    self = [super init];
	    if (self) {
	        self.stringPassed = str;
	    }
	    return self;
    }

（3）单例设计模式的本质
    在创建单例实例的代码中，有一个函数颇让人好奇，即dispatch_once。Apple的官方文档是这样解释的：在整个App的声明周期中，这个Block只执行一次，而且是唯一的一次。
	void dispatch_once(dispatch_once_t *predicate, DISPATCH_NOESCAPE dispatch_block_t block);
    其中，predicate参数是指向dispatch_once_t的指针，dispatch_once_t是一个结构体，predicate用来判断这个block是否执行完毕，而且这个block只执行一次。我们看到，函数dispatch_once在整个App生命周期中，仅执行一次block对象。这简直就是为单例而生的。这样说来，如果想确保某个初始化的工作仅执行一次，也可以放在这个dispatch_once来执行。
    现在来总结一下dispatch_once的应用。
    （1）这个方法可以在创建单例或者某些初始化动作时使用，以保证其唯一性。
    （2）该方法是线程安全的，可以 在子线程中放心使用。前提是“dispatch_once_t *predicate”对象必须是全局或者静态对象，这一点很重要，如果不能保证这一点，也就不能保证该方法只会执行一次

（4）通过单例实现传值
    传值的场景与Delegate章节一样：有两个ViewControllerA和ViewControllerB（简称A和B），A跳转到B，在B中输入的UITextField值，返回到A；A中的UILabel显示B所输入的值。
        在ViewControllerB.m中，编写以下代码。
	#import "ViewControllerB.h"
	#import "MySharedInstance.h"
	
	@interface ViewControllerB () <UITextFieldDelegate>
	@property(weak, nonatomic) IBOutlet UITextField *inputInformation;
	@end
	
	@implementation ViewControllerB
	
	// 单击输入键盘的完成按钮时，触发这个UITextFieldDelegate的方法
	- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	    MySharedInstance *myInstance = [MySharedInstance sharedInstance];
	    // 将输入的文字保存到单例的属性变量中
	    myInstance.stringPassed = self.inputInformation.text;
	    // ViewControllerB消失
	    [self.navigationController popViewControllerAnimated:YES];
	    // 键盘释放
	    [textField resignFirstResponder];
	    return YES;
	}
	@end
    
    在ViewControllerA.m文件中，输入以下代码。
	#import "ViewControllerA.h"
	#import "MySharedInstance.h"
	
	@interface ViewControllerA ()
	@property(weak, nonatomic) IBOutlet UILabel *showInformation;
	@end
	
	@implementation ViewControllerA
	
	- (void)viewDidLoad {
	    [super viewDidLoad];
	    // Do any additional setup after loading the view, typically from a nib.
	}
	
	- (void)viewWillAppear:(BOOL)animated {
	    [super viewWillAppear:animated];
	    // 获取单例实例
	    MySharedInstance *myInstance = [MySharedInstance sharedInstance];
	    // 将单例中的属性变量（stringPassed）赋给A中的UILabel
	    self.showInformation.text = myInstance.stringPassed;
	}
    @end

（5）单例模式在登录模块中的应用
    把登录用户用单例模式来创建，登录成功时，给单例赋值。这样就确保了只有一个用户对象存在，在应用程序的其他类里面，都可以共享这个单例。这样一来，在任何地方，都可以获取到登录用户的属性，也可以修改登录用户的属性。而这样的一个用户对象，必然是一个全局的对象，用单例模式来实现，是最合适的。
    单纯地声明和实现一个单例并不复杂，有现成的套路可参考，这里给出部分代码片段。基于NSObject创建一个UserInfo类，UserInfo.h文件的代码如下。
	#import <Foundation/Foundation.h>
	#import "Singleton.h"
	
	@interface UserInfo : NSObject
	singleton_interface(UserInfo);
	@property(nonatomic, copy) NSString *user;  // 用户名
	// 声明更多的属性变量.......
	@end
	
    对于单例的声明，我们换一种实现方式，现在通过Singleton的宏定义来实现。在Singleton.h文件中，添加以下代码。
	#import <Foundation/Foundation.h>
	
	// Singleton.h
	#define singleton_interface(class) + (instancetype)shared##class;
	
	// Singleton.m
	#define singleton_implementation(class) \
	static class *_instance;    \
	\
	+ (id)allocWithZone:(struct _NSZone *)zone  \
	{   \
	    static dispatch_once_t onceToken;   \
	    dispatch_once(&onceToken, ^{    \
	        _instance = [super allocWithZone:zone]; \
	    }); \
	    return _instance;   \
	}   \
	\
	+ (instancetype)shared##class   \
	{   \
	    if (_instance == nil) { \
	        _instance = [[class alloc] init];   \
	    }   \
	    return _instance;   \
	}
    善用宏定义，可以让代码更加简洁、有效。对于较长的宏定义代码，一定要注意转义字符和反斜杠“\”的用法，虽然看上去怪怪的，但其至关重要，切不可随意删掉。
    然后，在对应的UserInfo.m文件中，添加以下代码。
	#import "UserInfo.h"
	
	@implementation UserInfo
	singleton_implementation(UserInfo)
	// 方法实现代码.......
    @end