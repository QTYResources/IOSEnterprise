UseBlock

通过Block实现视图控制器之间的逆向传值

（1）在视图控制器B中定义Block
    // 自定义一个Block
    typedef void(^ReturnTextBlock)(NSString *showText);

    @interface SceneBViewController : UIViewController <UITextFieldDelegate>

    @property (nonatomic, weak) IBOutlet UITextField *inputInformation;

    // 声明一个调用Block的方法
    - (void)returnText:(ReturnTextBlock)block;
    @end

（2）在视图控制器B中按下Return键后调用Block
    - (BOOL)textFieldShouldReturn:(UITextField *)textField {
        // 判断属性变量（Block）是否为空
        if (self.retBlock) {
            // 执行Block属性变量，输入参数是UITextField的内容
            self.retBlock(self.inputInformation.text);
            // Scene B消失
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        // 隐藏键盘
        [textField resignFirstResponder];
        return YES;
    }

（3）在视图控制器A中给视图控制器B的Block变量赋值
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if ([segue.identifier isEqualToString:@"SceneBViewController"]) {
            SceneBViewController *sceneBVC = segue.destinationViewController;
            // 将scene A的Block传递给Scene B的Block属性变量
            [sceneBVC returnText:^(NSString *showText) {
                self.showInformation.text = showText;
            }];
        }
    }