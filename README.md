 > 利用UIActivityViewController实现系统原生分享，不需要三方SDK，支持自定义分享，可以分享到微博、微信、QQ、信息、邮件、备忘录、通讯录、剪贴板、FaceBook.....等等  [示例Github](https://github.com/wslcmk/UIActivityViewController.git)

> 注意：iOS10之前需要在系统设置中登陆Facebook和twwiter账号才能分享，iOS10之后就不 支持原生分享facebook和twwiter了，需要嵌入官方的sdk，自定义UIActivity才行。

效果图，诸位请看：
![效果1.gif](http://upload-images.jianshu.io/upload_images/1708447-2417de6295f29f14.gif?imageMogr2/auto-orient/strip)


![效果2.gif](http://upload-images.jianshu.io/upload_images/1708447-75e976664d6b63c3.gif?imageMogr2/auto-orient/strip)


接下来介绍UIActivityViewController：[Demo里也注释的很清楚](https://github.com/wslcmk/UIActivityViewController.git)

    1. 创建要分享的数据内容，加在一个数组 ActivityItems里。
    NSString *textToShare = @"我是且行且珍惜_iOS，欢迎关注我！";
    UIImage *imageToShare = [UIImage imageNamed:@"wang.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/wslcmk"];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
       //自定义 customActivity继承于UIActivity,创建自定义的Activity加在数组Activities中。
       customActivity * custom = [[customActivity alloc] initWithTitie:@"且行且珍惜_iOS" withActivityImage:[UIImage imageNamed:@"wang"] withUrl:urlToShare withType:@"customActivity" withShareContext:activityItems];
    NSArray *activities = @[custom];
    


这里需要注意：不同的 Activity 类型所支持的数据类型不同，当不支持时，应用程序支持的系统服务按钮就不会出现，比如说打印、添加书签，，，，

![不同的 Activity 类型所支持的数据类型.png](http://upload-images.jianshu.io/upload_images/1708447-71dcf1ba4ecfcdef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    /**
    2. //创建分享视图控制器，初始化UIActivityViewController
 
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     */

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:activities];


       // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
    //关闭系统的一些Activity类型,不需要的功能关掉。
     activityVC.excludedActivityTypes = @[UIActivityTypePostToVimeo ];

    //Activity 类型又分为“操作”和“分享”两大类
    /*
     UIKIT_EXTERN NSString *const UIActivityTypePostToFacebook     NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToTwitter      NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToWeibo        NS_AVAILABLE_IOS(6_0);    //SinaWeibo
     UIKIT_EXTERN NSString *const UIActivityTypeMessage            NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeMail               NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePrint              NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeCopyToPasteboard   NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAssignToContact    NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeSaveToCameraRoll   NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAddToReadingList   NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToFlickr       NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToVimeo        NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToTencentWeibo NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAirDrop            NS_AVAILABLE_IOS(7_0);
     */

     3. //判断系统版本,初始化点击回调方法
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        //此Block回调方法在iOS8.0之后就弃用了，被上面的所取代
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    }
    
    4. //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    [self presentViewController:activityVC animated:YES completion:nil];


接下来介绍几个系统Activity 类型的API，用于自定义title、Image的时候用。
    - (void)SystemAPI{
    
    //复制链接功能
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"需要复制的内容";
    
    //用safari打开网址
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
    
    //保存图片到相册
    UIImage *image = [UIImage imageNamed:@"wang"];
    id completionTarget = self;
    SEL completionSelector = @selector(didWriteToSavedPhotosAlbum);
    void *contextInfo = NULL;
    UIImageWriteToSavedPhotosAlbum(image, completionTarget, completionSelector, contextInfo);
    
    
    //添加书签
    NSURL *URL = [NSURL URLWithString:@"https://github.com/wslcmk"];
    BOOL result = [[SSReadingList defaultReadingList] addReadingListItemWithURL:URL
                                                                          title:@"WSL"
                                                                    previewText:@"且行且珍惜_iOS"
                                                                          error:nil];
    if (result) {
        NSLog(@"添加书签成功");
    }
    
    
    //发送短信
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.recipients = @[@"且行且珍惜_iOS"];
    //messageComposeViewController.delegate = self;
    messageComposeViewController.body = @"你好，我是且行且珍惜_iOS，请多指教！";
    messageComposeViewController.subject = @"且行且珍惜_iOS";
    
    
    
    //发送邮件
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    [mailComposeViewController setToRecipients:@[@"mattt@nshipster•com"]];
    [mailComposeViewController setSubject:@"WSL"];
    [mailComposeViewController setMessageBody:@"Lorem ipsum dolor sit amet"
                                       isHTML:NO];
    if([MFMailComposeViewController  canSendMail]){
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    };
    
    
    
    //发送推文
    TWTweetComposeViewController *tweetComposeViewController =
    [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setInitialText:@"梦想还是要有的,万一实现了呢!-----且行且珍惜_iOS"];
    [tweetComposeViewController addURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
    [tweetComposeViewController addImage:[UIImage imageNamed:@"wang"]];
    if ([TWTweetComposeViewController canSendTweet]) {
        [self presentViewController:tweetComposeViewController animated:YES completion:nil];
    }
    }
接下来介绍自定义UIActivity，主要就是重写了以下方法：
    + (UIActivityCategory)activityCategory{
    // 决定在UIActivityViewController中显示的位置，最上面是AirDrop，中间是Share，下面是Action
    return UIActivityCategoryAction;}

    - (NSString *)activityType{
    return _type;}

    - (NSString *)activityTitle {
    return _title;}

    - (UIImage *)_activityImage {
    //这个得注意，当self.activityCategory = UIActivityCategoryAction时，系统默认会渲染图片，所以不能重写为 - (UIImage *)activityImage {return _image;}
    return _image;}

    - (NSURL *)activityUrl{
    return _url;}

    - (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;}

    - (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据。;}

    - (void)performActivity {
    //这里就可以关联外面的app进行分享操作了
    //也可以进行一些数据的保存等操作
    //操作的最后必须使用下面方法告诉系统分享结束了
    [self activityDidFinish:YES];}

[需要Demo请戳我](https://github.com/wslcmk/UIActivityViewController.git)

![亲，赞一下，给个star.gif](http://upload-images.jianshu.io/upload_images/1708447-0c218b4b69db52b3.gif?imageMogr2/auto-orient/strip)


欢迎扫描下方二维码关注——iOS开发进阶之路——微信公众号：iOS2679114653
本公众号是一个iOS开发者们的分享，交流，学习平台，会不定时的发送技术干货，源码,也欢迎大家积极踊跃投稿，(择优上头条) ^_^分享自己开发攻城的过程，心得，相互学习，共同进步，成为攻城狮中的翘楚！

![微信公众号：iOS2679114653.jpg](http://upload-images.jianshu.io/upload_images/1708447-cc84ff7ef01c513a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
