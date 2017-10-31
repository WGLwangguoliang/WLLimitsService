//
//  WLLimitsService.m
//  OffLineCache
//
//  Created by Json on 16/12/22.
//  Copyright © 2016年 Json. All rights reserved.
//

#import "WLLimitsService.h"
// 定位
#import <CoreLocation/CoreLocation.h>
// 通知
#import <UserNotifications/UserNotifications.h>
// 摄像头 麦克风
#import <AVFoundation/AVFoundation.h>
// 相册
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
// 通讯录
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
// 蓝牙
#import <CoreBluetooth/CoreBluetooth.h>
// 联网
#import <CoreTelephony/CTCellularData.h>
// 健康
#import <HealthKit/HealthKit.h>
// Touch ID
#import <LocalAuthentication/LocalAuthentication.h>
// Apple Pay
#import <PassKit/PassKit.h>

#import <s>

@implementation WLLimitsService

#pragma mark - 开启定位服务
+ (void)openLocationServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOpen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOpen = YES;
    }
    if (returnBlock) {
        returnBlock(isOpen);
    }
}

#pragma mark - 开启消息推送服务
+ (void)openMessageNotificationServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if (returnBlock) {
            returnBlock(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        }
    }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (returnBlock) {
        returnBlock([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (returnBlock) {
        returnBlock(type != UIRemoteNotificationTypeNone);
    }
#endif
}

#pragma mark - 开启摄像头服务
+ (void)openCaptureDeviceServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#endif
}

#pragma mark - 开启相册服务
+ (void)openAlbumServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOpen;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    isOpen = YES;
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        isOpen = NO;
    }
#else
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    isOpen = YES;
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        isOpen = NO;
    }
#endif
    if (returnBlock) {
        returnBlock(isOpen);
    }
}

#pragma mark - 开启麦克风服务
+ (void)openRecordServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#endif
}

#pragma mark - 开启通讯录服务
+ (void)openContactsServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (cnAuthStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (cnAuthStatus == CNAuthorizationStatusRestricted || cnAuthStatus == CNAuthorizationStatusDenied) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#else
    //ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                    if (returnBlock) {
                        returnBlock(NO);
                    }
                } else {
                    if (returnBlock) {
                        returnBlock(YES);
                    }
                }
            });
        });
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#endif
}

#pragma mark - 开启蓝牙服务
+ (void)openPeripheralServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOpen = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    CBPeripheralManagerAuthorizationStatus cbAuthStatus = [CBPeripheralManager authorizationStatus];
    if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
        isOpen = NO;
    } else if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusRestricted || cbAuthStatus == CBPeripheralManagerAuthorizationStatusDenied) {
        isOpen = NO;
    }
    if (returnBlock) {
        returnBlock(isOpen);
    }
#endif
}

#pragma mark - 开启日历/备忘服务
+ (void)openEventServiceWithBlock:(ReturnBlock)returnBlock withType:(EKEntityType)entityType
{
    // EKEntityTypeEvent    代表日历
    // EKEntityTypeReminder 代表备忘
    EKAuthorizationStatus ekAuthStatus = [EKEventStore authorizationStatusForEntityType:entityType];
    if (ekAuthStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:entityType completion:^(BOOL granted, NSError *error) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (ekAuthStatus == EKAuthorizationStatusRestricted || ekAuthStatus == EKAuthorizationStatusDenied) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
}

#pragma mark - 开启联网服务
+ (void)openEventServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            if (returnBlock) {
                returnBlock(NO);
            }
        } else {
            if (returnBlock) {
                returnBlock(YES);
            }
        }
    };
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#endif
}

#pragma mark - 开启健康服务
+ (void)openHealthServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (![HKHealthStore isHealthDataAvailable]) {
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        HKObjectType *hkObjectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
        HKAuthorizationStatus hkAuthStatus = [healthStore authorizationStatusForType:hkObjectType];
        if (hkAuthStatus == HKAuthorizationStatusNotDetermined) {
            // 1. 你创建了一个NSSet对象，里面存有本篇教程中你将需要用到的从Health Stroe中读取的所有的类型：个人特征（血液类型、性别、出生日期）、数据采样信息（身体质量、身高）以及锻炼与健身的信息。
            NSSet <HKObjectType *> * healthKitTypesToRead = [[NSSet alloc] initWithArray:@[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],[HKObjectType workoutType]]];
            // 2. 你创建了另一个NSSet对象，里面有你需要向Store写入的信息的所有类型（锻炼与健身的信息、BMI、能量消耗、运动距离）
            NSSet <HKSampleType *> * healthKitTypesToWrite = [[NSSet alloc] initWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],[HKObjectType workoutType]]];
            [healthStore requestAuthorizationToShareTypes:healthKitTypesToWrite readTypes:healthKitTypesToRead completion:^(BOOL success, NSError *error) {
                if (returnBlock) {
                    returnBlock(success);
                }
            }];
        } else if (hkAuthStatus == HKAuthorizationStatusSharingDenied) {
            if (returnBlock) {
                returnBlock(NO);
            }
        } else {
            if (returnBlock) {
                returnBlock(YES);
            }
        }
    }
#endif
}

#pragma mark - 开启Touch ID服务
+ (void)openTouchIDServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    LAContext *laContext = [[LAContext alloc] init];
    laContext.localizedFallbackTitle = @"输入密码";
    NSError *error;
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"恭喜,Touch ID可以使用!");
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError *error) {
            if (success) {
                // 识别成功
                if (returnBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        returnBlock(YES);
                    }];
                }
            } else if (error) {
                if (returnBlock) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        returnBlock(NO);
                    }];
                }
                if (error.code == LAErrorAuthenticationFailed) {
                    // 验证失败
                }
                if (error.code == LAErrorUserCancel) {
                    // 用户取消
                }
                if (error.code == LAErrorUserFallback) {
                    // 用户选择输入密码
                }
                if (error.code == LAErrorSystemCancel) {
                    // 系统取消
                }
                if (error.code == LAErrorPasscodeNotSet) {
                    // 密码没有设置
                }
            }
        }];
    } else {
        NSLog(@"设备不支持Touch ID功能,原因:%@",error);
        if (returnBlock) {
            returnBlock(NO);
        }
    }
#endif
}

#pragma mark - 开启Apple Pay服务
+ (void)openApplePayServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    NSArray<PKPaymentNetwork> *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
    if ([PKPaymentAuthorizationViewController canMakePayments] && [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        if (returnBlock) {
            returnBlock(YES);
        }
    } else {
        if (returnBlock) {
            returnBlock(NO);
        }
    }
#endif
}

#pragma mark - 手机是否静音服务
/*
+ (void)openWithBlock:(ReturnBlock)returnBlock
{
    // 返回YES 就是静音
#if TARGET_IPHONE_SIMULATOR
    if (returnBlock) {
        returnBlock(YES);
    }
#else
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    // iOS 5+ doesn't allow mute switch detection using state length detection
    // So we need to play a blank 100ms file and detect the playback length
    soundDuration = 0.0;
    CFURLRef soundFileURLRef;
    SystemSoundID soundFileObject;
    
    // Get the main bundle for the app
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    
    // Get the URL to the sound file to play
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR ("detection"), CFSTR ("aiff"), NULL);
    
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
    
    AudioServicesAddSystemSoundCompletion(soundFileObject, NULL, NULL, soundCompletionCallback,
                                           (void*) self);
    
    // Start the playback timer
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(incrementTimer) userInfo:nil repeats:YES];
    // Play the sound
    AudioServicesPlaySystemSound(soundFileObject);
#else
    // This method doesn't work under iOS 5+
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0) { // 有声音
        if (returnBlock) {
            returnBlock(NO);
        }
    } else {
        if (returnBlock) {
            returnBlock(YES);
        }
    }
#endif
#endif
}
*/
@end
