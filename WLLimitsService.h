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

 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenLocationServiceWithBolck:(ReturnBlock)returnBolck;

/**
 是否开启推送消息服务
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenMessageNotificationServiceWithBolck:(ReturnBlock)returnBolck;

/**
 是否开启摄像头服务 要求iOS7以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenCaptureDeviceServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(7_0);

/**
 是否开启相册服务
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenAlbumServiceWithBolck:(ReturnBlock)returnBolck;

/**
 是否开启麦克风服务 要求iOS8以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenRecordServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);

/**
 是否开启通讯录服务
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)isOpenContactsServiceWithBolck:(ReturnBlock)returnBolck;

/**
 是否开启蓝牙服务 要求iOS7以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(7_0);


/**
 是否开启日历/备忘录服务

 @param returnBolck 返回YES:开启,返回NO:关闭
 @param entityType EKEntityTypeEvent:日历,EKEntityTypeReminder:备忘录
 */
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType)entityType;

/**
 是否开启联网服务 要求iOS9以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(9_0);

/**
 是否开启健康服务 要求iOS8以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);

/**
 是否开启Touch ID服务 要求iOS8以上
 
 @param returnBolck 返回YES:开启,返回NO:关闭
 */
+ (void)openTouchIDServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);

@end
