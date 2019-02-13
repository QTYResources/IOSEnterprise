iOS 基础知识

（1）定义类
    1. 定义类。
        #import <Foundation/Foundation.h>

        @interface Card : NSObject
        @property (nonatomic, strong) NSString *contents;    // 声明一个属性
        @property (nonatomic) BOOL onSwitch;
        @end

    2. 实现类。
        #import "Card.h"

        @implementation Card

        @end

（2）创建NSString对象
    NSString *myString = @"hello";
    NSString *otherString = [myString stringByAppendingString:@"world"];
    NSString *str = [NSString stringWithFormat:@"%d%@", 10, @"岁"];

（3）判断两个NSString对象是否相等
    NSString *strA = @"abc";
    NSString *strB = [[NSString alloc] initWithString:@"abc"];
    // strA是字符串，strB是指字符串"abc"的对象指针
    if (strA == strB) {
        NSLog(@"A is equal to B");
    } else {
        NSLog(@"A is not equal to B");
    }

    // 正确的判断两个字符串是否相等的方法
    if ([strA isEqualToString:strB]) {    // 判断的是字符串的内容
        NSLog(@"strA is equals to strB");
    } else {
        NSLog(@"strA is not equal to strB");
    }

（4）NSNumber的使用
    NSNumber *charNumber = [NSNumber numberWithChar:'c'];
    NSNumber *intNumber = [NSNumber numberWithInt:12];
    NSNumber *floatNumber = [NSNumber numberWithFloat:10.9f];
    NSNumber *boolNumber = [NSNumber numberWithBool:TRUE];

    // 获取对象的整型值
    int myInt = intNumber.intValue;

    // 将整型添加到NSArray的方法
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
    [myMutableArray addObject:intNumber];

（5）不可变数组与可变数组的使用
    // 遍历数组中的对象
    NSArray *myArray = @[@"a", @"b", @"c"];

    // 先计算数组中有多少个对象，通过NSArray的count方法
    for (int i = 0; i < [myArray count]; i++) {
        // 根据数组的下标，获取到数组的对象
        NSLog(@"for loop: %@", myArray[i]);
    }

    // 使用for-in语句遍历数组中的对象
    for (NSString * string in myArray) {
        NSLog(@"NSString: %@", string);
    }

    // 使用for-in语句需要注意一点，编译器并不知道数组中存在哪些类型的对象
    for (NSString * string in myArray) {
        // 如果数组中不完全是NSString类型的对象，在这种情况下，程序将出现闪退（Crash）
        int value = [string integerValue];
    }

    // 在这种情况下，将采用一种更为通用的方法，j先将NSArray中的对象类型视为id类型，在对id进行操作时，
    // 再判断对象的具体类型。
    for (id obj in myArray) {
        // 判断对象的类型，只有满足条件，才做处理
        if ([obj isKindOfClass:[NSString class]]) {
            // 对NSString类型的对象，进行方法调用
            int value = [obj integerValue];
        }
    }

    // 为支持addObject方法，这里必须声明为NSMutableArray
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:numberOfColors];
    for (NSInteger i = 0; i < numberOfColors; i++) {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        [tempArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    // 将NSMutableArray中的数据复制到NSArray中
    colorArray = [NSArray arrayWithArray:tempArray];

（6）可变字典与不可变字典的使用
    1. 创建NSDictionary
        NSDictionary *colors = @{
            @"green":[UIColor greenColor],     // green的key-value
            @"blue":[UIColor blueColor],          // blue的key-value
            @"red":[UIColor redColor]              // red的key-value
        };
    2. 获取键对应的值
        第一种方法为：
            NSString *colorKey = @"red";
            UIColor *colorObject = colors[colorKey];
        第二种方法为：
	        UIColor *colorObject = [colors objectForKey:@"red"];
    3. NSMutableDictionary还独有以下方法：
        - (void)setObject:(id)anObject forKey:(id)key;    // 添加一对Key-Object
        - (void)removeObjectForKey:(id)key;               // 删除一对Key-Object
        - (void)removeAllObjects;                         // 删除字典内所有的Object
    4. 遍历字典
        NSDictionary *myDictionary = ...;
        for (id key in myDictionary) {
            id value = [myDictionary objectForKey:key];   // 通过key，获取到对应的Value
            /* 在这里，对Value进行操作 */
        }

（7）使用NSUserDefaults存储数据
    // 通过sharedApplication获取该程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 1;
    NSArray *myArray = [NSArray array];
    
    NSUserDefaults * myUserDefaults = [NSUserDefaults standardUserDefaults];
    [myUserDefaults setObject:myArray forKey:@"RecentlyViewed"];
    
    // 一定要记得调用synchronize方法，否则上面存储的数据无效
    [[NSUserDefaults standardUserDefaults] synchronize];

（8）懒加载
    1. 在ViewController.m文件中添加一下代码：
        @interface ViewController ()
        @property(nonatomic, strong) UILabel *firstLabel;
        @end
    2. 通常的做法是在初始化方法里对它进行alloc、init操作，例如：
	    self.firstLabel = [[UILabel alloc] init];
    3. 当用到懒加载时，我们会重写它的getter方法，代码如下：
        // 重写firstLabel的getter方法
        - (UILabel *)firstLabel {
            // 必须先判断_firstLabel这个实力对象是否存在，若没有，则进行实例化
            if (!_firstLabel) {
                _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 300, 30)];
                [_firstLabel setTextAlignment:NSTextAlignmentCenter];
                // 在这个getter方法中，切不可使用self.firstLabel，这是因为self.firstLabel本身就是在调用getter方法，这样会造成死循环
                [self.view addSubview:_firstLabel];
            }
            
            return _firstLabel;
        }

（9）UILabel的特殊使用
    [self.firstLabel setText:@"原价：￥199"];
    NSUInteger length = [self.firstLabel.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:self.firstLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(4, length - 4)];
    self.firstLabel.attributedText = attri;

（10）如何实现输入框随键盘上移
    这个功能还有问题，只要记住思路即可
    • 当虚拟键盘弹出时，需要判断输入焦点的位置是否被键盘遮住，如果遮住了，需要上移输入框，而上移多少需要计算。
	• 当触摸整个View时，输入框应释放焦点，虚拟键盘消失。
        代码实现如下：
	- (void)viewDidLoad {
	    [super viewDidLoad];
	    
	    // 为View注册一个手势，触摸View时触发Target-Action
	    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
	    [self.view addGestureRecognizer:tapG];
	}
	
	#pragma mark -- 解决虚拟键盘挡住UITextField的方法
	// 当某个TextField处于输入状态时
	- (void)textFieldDidBeginEditing:(UITextField *)textField {
	    CGRect frame = textField.frame;
	    // 键盘高度为216
	    int offset = frame.origin.y + 162 - (self.view.frame.size.height - 216.0);
	    NSTimeInterval animationDuration = 0.30f;
	    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	    [UIView setAnimationDuration:animationDuration];
	    float width = self.view.frame.size.width;
	    float height = self.view.frame.size.height;
	    if (offset > 0) {    // 判断是否有必要上移View
	        CGRect rect = CGRectMake(0.0f, -offset, width, height);
	        self.view.frame = rect;
	    }
	    [UIView commitAnimations];
	}
	
	// 输入完成后，键盘消失。添加动画，让键盘的消失有个过渡效果
	- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	    NSTimeInterval animationDuration = 0.30f;
	    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	    [UIView setAnimationDuration:animationDuration];
	    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
	    self.view.frame = rect;
	    [UIView commitAnimations];
	    [textField resignFirstResponder];
	    return YES;
	}
	
	#pragma mark -- 触摸View时
	- (void)tap {
	    NSTimeInterval animationDuration = 0.30f;
	    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	    [UIView setAnimationDuration:animationDuration];
	    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
	    self.view.frame = rect;
	    [UIView commitAnimations];
	    [self.view endEditing:YES];
	}
        关于键盘遮挡输入框的问题，苹果官方文档给出了参考方案，通过观察者模式来实现先注册观察者，用来监听UIKeyboardWillShow和UIKeyboardWillHide事件。
	- (void)viewWillAppear:(BOOL)animated {
	    [super viewWillAppear:animated];
	    
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	}
        实现自定义的方法如下：
	- (void)keyboardWillShow:(NSNotification *)aNotification {
	    NSDictionary *userInfo = [aNotification userInfo];
	    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	    CGRect newFrame = self.view.frame;
	    newFrame.size.height -= keyboardRect.size.height;
	    [UIView beginAnimations:@"ResizeTextView" context:nil];
	    [UIView setAnimationDuration:animationDuration];
	    self.view.frame = newFrame;
	    [UIView commitAnimations];
	}
	
	- (void)keyboardWillHide:(NSNotification *)aNotification {
	    NSDictionary *userInfo = [aNotification userInfo];
	    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	    CGRect newFrame = self.view.frame;
	    newFrame.size.height += keyboardRect.size.height;
	    [UIView beginAnimations:@"ResizeTextView" context:nil];
	    [UIView setAnimationDuration:animationDuration];
	    self.view.frame = newFrame;
	    [UIView commitAnimations];
	}
        最后，移除观察者，代码如下：
	- (void)viewDidDisappear:(BOOL)animated {
	    [super viewDidDisappear:animated];
	    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	}


（11）视图层级管理
    • addSubView：在父视图上添加一个子视图。
	• removeFromSuperView：将当前的子视图从器父视图中移除掉。
	• bringSubviewToFront：同一个父视图里面有多个子视图，如果想将一个UIView显示在父视图的最前面，可以调用bringSubviewToFront方法。
	• sendSubviewToBack：同样，将一个UIView层放到背后，也就是父视图里面的最后端，就可以调用其父视图的sendSubviewToBack方法。

    1. 移除所有的子视图
    	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

（12）iOS编程规范
    1. 作为企业级应用，通常有以下几个特点：
        • 带有鲜明的行为领域的特征。
        • 业务逻辑复杂，涉及大量的数据和多人协同处理。
        • 通常是由一个开发团队共同完成的。
        • 完成发布后，还要考虑后期的运营与推广。
            为避免代码维护时期推倒重来，我们可以事先做好防范。
        • 工程的基础框架，要给每一位团队成员讲清楚，大家按照统一的套路出牌。
        • 尽快实现某一个需求的方案有多种，在给定的场景下，最优方案只有一个。
        • 实际业务逻辑的，一定要给出注释。
            工程命名：创建工程时，必须用英文或拼音来命名，不能用中文；虽说用中文命名也可以编译运行，但在有些情况下，会出现莫名其妙的编译错误。
            类名与变量名：类名的首字母需要大写，变量的首字母要小写。 
    2. 在由多人合作的项目中，需要约法三章，避免不必要的麻烦。通常，我们会做以下约定。
        • 工程命名：创建工程时，必须用英文或拼音来命名，不能用中文。
        • 新创建的文件，在文件历史记录的注释中，要加上文件创建者的名字。
        • 常量命名：在常量前面加上字母k作为前缀标记。
        • 类名与变量名的命名：类名的首字母需要大写，变量的首字母要小写。
        • 与业务逻辑相关的if语句，务必加上注释。
        • 资源文件不要直接拖曳到工程中，而是先创建文件夹，再导入资源文件。
    3. 面向对象的编程思想
        a. 判断nil或者YES/NO时，最好采用以下判断方式。
            if (someObject) {
                ...
            }
            if (!someObject) {
                ...
            }
        而不建议使用以下风格。
            if (someObject == YES) {
                ...
            }
            if (someObject != nil) {
                ...
            }
        b. 注意区分NSArray与NSMutableArray的使用，遍历时用NSArray。
        c. 定义属性变量是，如果内部使用的属性，那么就定义成私有属性（在.m文件中声明属性变量）。
        d. 在.h中声明的属性变量，通过self.引用；在.m的class extension声明的变量，建议以下划线“_”打头。
        e. 当用到假数据或Hard Code（硬编码）的地方，务必加上一行"#warning......"。在产品发布前，统一排查编译出现的warning，以求做到万无一失。
        f. 在添加对象到NSMutableArray、NSMutableDictionary时，要添加判空保护。
    4. 优先编译轻量级的ViewController
        要编写轻量级的ViewController，需要注意一下事项。
            a. 把DataSource和其他Protocols分离出来。比如，UITableView中的DataSource大多是对数组的操作，这时，就可以把与数组操作相关的代码一道单独的类中，可以使用Block或者Delegate来设置一个Cell。
            b. 把业务逻辑、网络请求放到Model中。与业务逻辑相关的代码要放到Model对象中。网络请求逻辑也要放到Model层中，不要在ViewController中左网络请求的逻辑，而是把网络请求封装到一个类中。在这种情况下，ViewController与网络请求的Mode怎么交互呢？当然可以通过Delegate或Block方式交互。
            c. 把View代码移到View层。不要在ViewController中构建复杂的View层次结构，可以把View封装到UIView的子类中。这样一来，对代码的重用和测试都带来很大的帮助。
        总体来说，ViewController主要做的事情是与其他关联的ViewController、Model、View之间进行通信。ViewController和Model对象之间的消息传递可以使用KVO、Delegate、Block和Notification；当一个ViewController需要把某个状态传递给其他多个ViewController时，可以使用代理模式处理。
