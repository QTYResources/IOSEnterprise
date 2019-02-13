DelegateUse

通过Delegate实现ViewController之间的传值

基于Single View Application模板，创建一个工程：在Storyboard编辑页面，默认有一个ViewController。从Objects Library中，再选中一个ViewController，拖曳到Storyboard编辑页面中；再分别创建两个类文件：SceneAViewController和SceneBViewController；最后做一个关联，将ViewController与新创建的类关联起来。
    在SceneA上，拖放一个Button和一个Label；在Scene B上拖放有一个TextField；对Scene A 的Label进行“Ctrl + Drag”的操作，声明Label的属性。SceneAViewController.h代码如下。
@interface SceneAViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *showInformation;
@end
    按照同样的方法，对Scene B的TextField进行“Ctrl + Drag”操作，声明TextField的属性。SceneBViewController.h代码如下。
@interface SceneBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputInformation;
@end
    创建一个Segue：选中Scene A中的Button，通过“Ctrl + Drag”操作，向SceneB拖曳。在弹出的窗口中，选择Model模式。选中这个Segue，将Segue identifier命名为Segue_ID_AB。先来运行下,你会看到，单击Button是会跳转到Scene B，单击输入框可以接受键盘的输入。
    我们的任务是单击键盘的“完成”按钮，返回到Scene B，并将输入的内容显示在Scene A中。
    解决的思路就是通过Delegate来实现，对于一个Delegate应用，通常需要五步来完成。
• 委托者声明一个Delegate。
• 委托者调用Delegate内的方法（Method）。
• 关联委托者与被委托者。
• 被委托者遵循Delegate协议。
• 被委托者重写Delegate内的方法。
    
    第一步：位图者声明一个Delegate
    在SceneBViewController.h文件中，通过@protocol创建一个Delegate并声明一个Delegate。
        @class SceneBViewController;

        @protocol SceneBViewControllerDelegate <NSObject>
        - (void)sceneBViewController:(SceneBViewController *)sceneBVC didInputed:(NSString *)string;
        @end

        @interface SceneBViewController : UIViewController
        @property (weak, nonatomic) IBOutlet UITextField *inputInformation;
        @property (weak, nonatomic) id<SceneBViewControllerDelegate> delegate;
        @end

    添加这几行代码后，SceneBViewController便拥有了Delegate，而且还可以调用Delegate中的方法。需要 注意的是，这个方法仅仅是一个“空壳”，具体做什么，需要被委托者来实现它。
    小贴士：
    通常，在用到Delegate的地方，都以Delegate命名，但这并不意味着所有的Delegate一定以Delegate来命名。在UITableView中，有两个常用的Delegate：UITableViewDelegate肯UITableViewDatasource。虽然UITableViewDatasource也是一个Delegate，但它并不是以Delegate来命名的。

    第二步：委托者调用Delegate内的方法
    我们的任务是将Scene B输入的内容告知Scene A，这要通过调用Delegate内的方法来实现。在SceneBViewController.m文件中，添加以下代码。
        - (BOOL)textFieldShouldReturn:(UITextField *)textField {
            if (self.delegate) {
                // 如果有了被委托者
                // 将UITextField内容传递给Delegate内的方法
                [self.delegate sceneBViewController:self didInputed:self.inputInformation.text];
                // 让当前呈现的Scene B页面消失
                [self.navigationController popViewControllerAnimated:YES];
            }
            // 让键盘消失
            [textField resignFirstResponder];
            return YES;
        }

    第三步：关联委托者与被委托者
    将Delegate与delegator关联，从本质上讲，也是一种传值，只不过这是一种正向传值罢了。而Scene之间的正向传值，就是发生在prepareForSegue中。
    这次，我们要在SceneAViewController.m文件中添加代码了，如下所示。
        - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
            if ([segue.identifier isEqualToString:@"Segue_ID_AB"]) {
                SceneBViewController *sceneBVC = segue.destinationViewController;
                sceneBVC.delegate = self;
            }
        }
    这段代码有两个知识点：
    （1）通过判断segue Identifier，得知这是从Scene A跳转到Scene B的操作。
    （2）获取到目标视图控制器（Destination View Controller），并明确告知SceneB，self（我）就是你的被委托者。这里的self就是SceneAViewController。

    第四步：被委托者遵循Delegate协议
    在SceneAViewController.h文件中，添加以下代码。
        #import "SceneBViewController.h"    // 将SceneBViewController.h引入进来
        @interface SceneAViewController () <SceneBViewControllerDelegate>

    第五步：被委托者重写Delegate内的方法
    在SceneAViewController.m文件中，添加以下代码。
        - (void)sceneBViewController:(id)sceneBVC didInputed:(NSString *)string {
            self.showInformation.text = string;
        }