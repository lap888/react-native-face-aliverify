//
//  AlifaceVerity.m
//  faceDemo
//
//  Created by top on 2019/12/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "AlifaceVerity.h"
#import<AlipayVerifySDK/APVerifyService.h>
#import <React/RCTUtils.h>

@implementation AlifaceVerity

RCT_EXPORT_MODULE(ZIMFacade);

@synthesize bridge = _bridge;

- (void)viewDidLoad {
  [super viewDidLoad];
}
- (UIViewController *)getVC
{
  UIViewController *controller = RCTKeyWindow().rootViewController;
  UIViewController *presentedController = controller.presentedViewController;
  while (presentedController && ![presentedController isBeingDismissed]) {
    controller = presentedController;
    presentedController = controller.presentedViewController;
  }
  return controller;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

RCT_EXPORT_METHOD(getZimFace:(NSString *)certName certNo:(NSString *)certNo successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback){
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:certName,@"certName",certNo,@"certNo",nil];
    if ([NSJSONSerialization isValidJSONObject:userDictionary])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://kumili.net/apiV2/FaceInit"]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:tempJsonData];
        //
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            /*
             对从服务器获取到的数据data进行相应的处理.
             */
            NSLog(@"从服务器获取到数据");
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"从服务器获取到数据 %@",result);
            if (result) {
                NSLog(@"响应");
                successCallback(@[result]);
            } else {
                errorCallback(@[@false]);
            }
        }];
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    }
}

RCT_EXPORT_METHOD(verify:(NSString *)url certId:(NSString *)certId callback:(RCTResponseSenderBlock)callback)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[APVerifyService sharedService] startVerifyService:@{@"url": url,@"certifyId": certId} target:root block:^(NSMutableDictionary * resultDic){
      NSLog(@"resultDic=%@", resultDic);
    }];
  });
}

@end
