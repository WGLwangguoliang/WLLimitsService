//
//  WLLimitsService.h
//  OffLineCache
//
//  Created by Json on 16/12/22.
//  Copyright © 2016年 Json. All rights reserved.
//

#import <Foundation/Foundation.h>
// 日历/备忘
#import <EventKit/EventKit.h>

#if NS_BLOCKS_AVAILABLE
typedef void(^ReturnBlock)(BOOL isOpen);
#endif

@interface WLLimitsService : NSObject

/**
 是否开启定位服务

 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openLocationServiceWithBlock:(ReturnBlock)returnBlock;

/**
 是否开启推送消息服务
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openMessageNotificationServiceWithBlock:(ReturnBlock)returnBlock;

/**
 是否开启摄像头服务 要求iOS7以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openCaptureDeviceServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(7_0);

/**
 是否开启相册服务
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openAlbumServiceWithBlock:(ReturnBlock)returnBlock;

/**
 是否开启麦克风服务 要求iOS8以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openRecordServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(8_0);

/**
 是否开启通讯录服务
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openContactsServiceWithBlock:(ReturnBlock)returnBlock;

/**
 是否开启蓝牙服务 要求iOS7以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openPeripheralServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(7_0);


/**
 是否开启日历/备忘录服务

 @param returnBlock 返回YES:开启,返回NO:关闭
 @param entityType EKEntityTypeEvent:日历,EKEntityTypeReminder:备忘录
 */
+ (void)openEventServiceWithBlock:(ReturnBlock)returnBlock withType:(EKEntityType)entityType;

/**
 是否开启联网服务 要求iOS9以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openEventServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(9_0);

/**
 是否开启健康服务 要求iOS8以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openHealthServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(8_0);

/**
 是否开启Touch ID服务 要求iOS8以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openTouchIDServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(8_0);

/**
 是否开启Apple Pay服务 要求iOS9以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openApplePayServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(9_0);

/**
 是否开启语音服务 要求iOS10以上
 
 @param returnBlock 返回YES:开启,返回NO:关闭
 */
+ (void)openSpeechServiceWithBlock:(ReturnBlock)returnBlock NS_AVAILABLE_IOS(10_0);

@end
