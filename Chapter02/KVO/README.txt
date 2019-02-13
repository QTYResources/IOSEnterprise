KVO

通过KVO实现ViewController之间的传值

（1） KVO的注册
    任意一个对象都可以注册KVO，当自身的属性发生变化时，通知到该对象的监听者。这个过程大部分是内建的、自动的、透明的。KVO的机制可以很方便地使用多个监听者监听同一属性的变化。
    注册通知使用“addObserver:forKeyPath:options:context:”方法实现，接下来看看各个参数的含义，注册KVO的函数定义如下。
	- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
    observer指注册KVO通知的对象，明确谁是观察者。观察者必须实现的回调方法“observerValueForKeyPath:ofObject:change:context”。这个回调方法用来监测被观察对象的变化，从而做出响应。
    keyPath为被观察者的属性，该值不能为nil。keyPath类型是一个字符串类型，而编译器无法检查字符串的拼写错误，为此，我们把keyPath声明为一个常量或宏定义。
    options是NSKeyValueObservingOptions定义的常量值的组合，这些值指定了在发出的观察通知中会包含哪些东西。不同的指定值会导致观察通知中包含的值不同。参数options的值决定了传向“observeValueForKeyPath:ofObject:change:context:”的change字典包含的值，如果传值为0，表示没有change字典值。NSKeyValueObservingOptions的定义可参考它的参数说明。
    context的值可以是任一数据值，会在“observeValueForKeyPath:ofObject:change:context:”的context参数的值相等。关于context参数，其作用是用来标识观察者的身份，在多个观察者观察同一键值时，尤其在处理父类和子类都观察同一键值时非常有用。

（2） 实现KVO的回调
    注册KVO之后，观察者需要实现“observeValueForKeyPath:ofObject:change:context:”其实现类似于：
	- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
    这里的KeyPath是相对于被监听对象object的键路径；object是键路径keyPath所属对象，即被监听对象；change用于描述被监听属性的变化信息；context在注册KVO时由监听者提供，用法参考以上对context的描述。

（3）移除KVO观察者
    当一个观察者完成了对某个对象的监听后，观察者的使命也就结束了。这时，需要调用“removeObserver:forKeyPath:context:”方法来移除观察者。该方法经常在“observeValueForKeyPath:ofObject:change:context:”被调用，或者在dealloc方法被调用，其目的就是移除之前注册的观察者。
    有时候，会出现这样的场景，本想调用“removeObserver:forKeyPath:context:”函数来移除一个观察者对象，但这个观察者对象可能没有注册，或者已经在别处被移除了，这时候，会抛出一个异常。Objective-C没有提供一个内建的方式来检查对象是否注册，我们只能采用常规的异常处理机制—@try和@catch，代码如下：
	- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {
	        if ([object isFinished]) {
	            @try {
	                [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished))];
	            } @catch (NSException * __unused exception) {}
	        }
	    }
	    
	    self.showInformation.text = [self.vcB valueForKey:@"textValue"];
	    // 移除观察者，这个观察者是self，也就是ViewControllerA
	    @try {
	        [self.vcB removeObserver:self forKeyPath:@"textValue"];
	        self.vcB = nil;
	    } @catch (NSException *exception) {
	        NSLog(@"remove Observer error: %@", exception.debugDescription);
	    }
	}

（4）通过KVO实现传值
    传值的应用场景与Delegate章节一样，有两个ViewControllerA和ViewControllerB（简称A和B），A跳转到B，在B中输入的UITextField值，返回到A；A中的UILabel显示B所输入的值。
    只要用到KVO，就需要遵循KVO的三步法：注册KVO、实现KVO的回调、移除KVO观察者。
	    a. 注册KVO：在SceneAViewController. m文件中，添加以下代码：
        #import "SceneAViewController.h"
        #import "SceneBViewController.h"
        
        @interface SceneAViewController ()
        // 声明一个属性变量，用来获取viewControllerB
        @property (nonatomic, strong) SceneBViewController *vcB;
        @property (weak, nonatomic) IBOutlet UILabel *showInformation;
        @end
        
        @implementation SceneAViewController
        
        - (void)viewDidLoad {
            [super viewDidLoad];
        }
        
        - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
            if ([segue.identifier isEqualToString:@"SceneBViewController"]) {
                self.vcB = segue.destinationViewController;
                [self.vcB addObserver:self forKeyPath:@"textValue" options:NSKeyValueObservingOptionNew context:nil];
            }
        }
        
        @end

	    在SceneBViewController.m文件中，添加以下代码：
        #import "SceneBViewController.h"
        
        @interface SceneBViewController () <UITextFieldDelegate>
        @property (nonatomic, copy) NSString *textValue;    // 被观察的属性对象
        
        @property (weak, nonatomic) IBOutlet UITextField *inputInformation;
        
        @end
        
        @implementation SceneBViewController
        
        - (void)viewDidLoad {
            [super viewDidLoad];
            // Do any additional setup after loading the view.
        }
        @end

        在SceneBViewController.m文件中，继续添加代码。当单击键盘的“完成”按钮时，调用键盘的Delegate方法，如下所示：
        #pragma mark - UITextFieldDelegate
        - (BOOL)textFieldShouldReturn:(UITextField *)textField {
            // 将UITextField内容赋给被观察的属性对象
            self.textValue = self.inputInformation.text;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            [textField resignFirstResponder];
            return YES;
        }
        
        b. 实现KVO的回调：在SceneAViewController.m文件中，实现KVO的回调方法。
        - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {    
            self.showInformation.text = [self.vcB valueForKey:@"textValue"];
            NSLog(@"keyPath: %@, observe: %@", keyPath, change);
        }
        
        c. 移除KVO：移除KVO的方法很简单，只需调用removeObserver:方法即可，问题是在哪里调用该方法呢？前面谈到，既可以在“observeValueForKeyPath:ofObject:change:context:”中调用，也可以在dealloc方法中调用，在这两个地方，都可以移除观察者。在这个示例中，采用第一种方法。在SceneAViewController.m文件中，添加如下代码：
	    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {    
            // 移除观察者，这个观察者是self，也就是ViewControllerA
            @try {
                [self.vcB removeObserver:self forKeyPath:@"textValue"];
                self.vcB = nil;
            } @catch (NSException *exception) {
                NSLog(@"remove Observer error: %@", exception.debugDescription);
            }
        }