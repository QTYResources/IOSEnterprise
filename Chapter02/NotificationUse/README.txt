NotificationUse

通过Notification实现ViewController之间的传值

    传值的应用场景与Delegate章节一样，有两个ViewControllerA和ViewControllerB（简称A和B），A跳转到B，在B中输入的UITextField值，返回到A；A中的UILabel显示B所输入的值。
 
    第一步：发送通知
    在SceneBViewController.m文件中，添加以下代码。思路是：在ViewControllerB中，发送通知给ViewControllerA，发送的通知附带了userInfo，这个userInfo附带了UITextField的内容。
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 创建一个NSDictionary，存放UITextField内容
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.inputInformation.text, @"value", nil];
    // 创建一个通知，通知的名字是myNotification
    NSNotification *notification = [NSNotification notificationWithName:@"myNotification" object:nil userInfo:dict];
    // 由通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [textField resignFirstResponder];
    return YES;
}

    第二步：接收通知
    在这个示例中，通知的接收方是ViewControllerA，在SceneAViewController.m中，添加如下代码。
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"myNotification" object:nil];
}

- (void)getNotification:(NSNotification *)info {
    self.showInformation.text = info.userInfo[@"value"];
}
    其中，addObserver:self中的self是指SceneAViewController，name:@"myNotification"是通知的名称为myNotification。对于通知的发送者与接收者，确保通知的名称必须是同一个，而且必须是唯一的，不能有重名的通知名字。在多人项目开发中，为了确保通知名称是唯一的，需要创建一个ENUM结构，把所有用到通知名称，都放到这个EMUN中。

    第三步：移除通知
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"myNotification" object:nil];
}
    注意：通知的注册与移除，一定要成双成对地出现，如果只在viewWillAppear中addObserver（注册通知）而没有在viewWillDisappear中removeObserver（移除通知），那么当通知发生时，会造成异常。

    注意：需要在viewDidLoad方法中注册通知及dealloc方法中移除通知，如果在viewWillAppear中注册通知及在viewWillDisappear中移除通知，在跳转到其他ViewController后，将会移除通知，这会导致该ViewController无法接收到其他ViewController发送的通知。