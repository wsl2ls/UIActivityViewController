//
//  customActivity.h
//  UIActivityViewController
//
//  Created by 王双龙 on 16/8/30.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customActivity : UIActivity

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;
@end
