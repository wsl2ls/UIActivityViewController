//
//  ViewController.m
//  UIActivityViewController
//
//  Created by 王双龙 on 16/8/30.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import "ViewController.h"
#import "customActivity.h"

#import <Social/Social.h>
@import SafariServices;
@import MessageUI;
@import Twitter;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)shareBtnClicked:(id)sender {
    
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = @"我是且行且珍惜_iOS，欢迎关注我！";
    UIImage *imageToShare = [UIImage imageNamed:@"wang.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/wslcmk"];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    //自定义Activity
    customActivity * custom = [[customActivity alloc] initWithTitie:@"且行且珍惜_iOS" withActivityImage:[UIImage imageNamed:@"wang"] withUrl:urlToShare withType:@"customActivity" withShareContext:activityItems];
    NSArray *activities = @[custom];
    
    /**
     创建分享视图控制器
     
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     
     */
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    //UIActivityViewControllerCompletionWithItemsHandler)(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)  iOS >=8.0
    
    //UIActivityViewControllerCompletionHandler (NSString * __nullable activityType, BOOL completed); iOS 6.0~8.0
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化回调方法
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
    
    // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
    //关闭系统的一些activity类型
    activityVC.excludedActivityTypes = @[];
    
    //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    [self presentViewController:activityVC animated:YES completion:nil];
    
}


- (void)elseAPI{
    
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
    [mailComposeViewController addAttachmentData:nil mimeType:nil fileName:nil];
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

//苹果自带的分享界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[SLComposeViewController isAvailableForServiceType: @"com.tencent.xin.sharetimeline"];微信
    
    
    //1.判断平台是否可用(系统没有集成,用户设置新浪账号)
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"到设置界面去设置自己的新浪账号");
        return;
    }
    
    // 2.创建分享控制器
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    // 2.1.添加分享的文字
    [composeVc setInitialText:@"梦想还是要有的,万一实现了呢!-----且行且珍惜_iOS"];
    
    // 2.2.添加分享的图片
    [composeVc addImage:[UIImage imageNamed:@"wang.png"]];
    
    // 2.3 添加分享的URL
    [composeVc addURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
    
    // 3.弹出控制器进行分享
    [self presentViewController:composeVc animated:YES completion:nil];
    
    // 4.设置监听发送结果
    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
        if (reulst == SLComposeViewControllerResultDone) {
            NSLog(@"用户发送成功");
        } else {
            NSLog(@"用户发送失败");
        }
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
