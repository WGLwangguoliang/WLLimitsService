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
@implementation WLLimitsService

#pragma mark - 开启定位服务
+ (void)isOpenLocationServiceWithBolck:(ReturnBlock)returnBolck
{
    BOOL isOpen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOpen = YES;
    }
    if (returnBolck) {
        returnBolck(isOpen);
    }
}

#pragma mark - 开启消息推送服务
+ (void)isOpenMessageNotificationServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if (returnBolck) {
            returnBolck(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        }
    }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (returnBolck) {
        returnBolck([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (returnBolck) {
        returnBolck(type != UIRemoteNotificationTypeNone);
    }
#endif
}

#pragma mark - 开启摄像头服务
+ (void)isOpenCaptureDeviceServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (returnBolck) {
                returnBolck(granted);
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

#pragma mark - 开启相册服务
+ (void)isOpenAlbumServiceWithBolck:(ReturnBlock)returnBolck
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
    if (returnBolck) {
        returnBolck(isOpen);
    }
}

#pragma mark - 开启麦克风服务
+ (void)isOpenRecordServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (returnBolck) {
                returnBolck(granted);
            }
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

#pragma mark - 开启通讯录服务
+ (void)isOpenContactsServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (cnAuthStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            if (returnBolck) {
                returnBolck(granted);
            }
        }];
    } else if (cnAuthStatus == CNAuthorizationStatusRestricted || cnAuthStatus == CNAuthorizationStatusDenied) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
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
                    if (returnBolck) {
                        returnBolck(NO);
                    }
                } else {
                    if (returnBolck) {
                        returnBolck(YES);
                    }
                }
            });
        });
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

#pragma mark - 开启蓝牙服务
+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck
{
    BOOL isOpen = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    CBPeripheralManagerAuthorizationStatus cbAuthStatus = [CBPeripheralManager authorizationStatus];
    if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
        isOpen = NO;
    } else if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusRestricted || cbAuthStatus == CBPeripheralManagerAuthorizationStatusDenied) {
        isOpen = NO;
    }
    if (returnBolck) {
        returnBolck(isOpen);
    }
#endif
}

#pragma mark - 开启日历/备忘服务
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType)entityType
{
    // EKEntityTypeEvent    代表日历
    // EKEntityTypeReminder 代表备忘
    EKAuthorizationStatus ekAuthStatus = [EKEventStore authorizationStatusForEntityType:entityType];
    if (ekAuthStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:entityType completion:^(BOOL granted, NSError *error) {
            if (returnBolck) {
                returnBolck(granted);
            }
        }];
    } else if (ekAuthStatus == EKAuthorizationStatusRestricted || ekAuthStatus == EKAuthorizationStatusDenied) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
}

#pragma mark - 开启联网服务
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            if (returnBolck) {
                returnBolck(NO);
            }
        } else {
            if (returnBolck) {
                returnBolck(YES);
            }
        }
    };
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

#pragma mark - 开启健康服务
+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (![HKHealthStore isHealthDataAvailable]) {
        if (returnBolck) {
            returnBolck(NO);
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
                if (returnBolck) {
                    returnBolck(success);
                }
            }];
        } else if (hkAuthStatus == HKAuthorizationStatusSharingDenied) {
            if (returnBolck) {
                returnBolck(NO);
            }
        } else {
            if (returnBolck) {
                returnBolck(YES);
            }
        }
    }
#endif
}

#pragma mark - 手机是否静音服务
/*
+ (void)openWithBolck:(ReturnBlock)returnBolck
{
    // 返回YES 就是静音
#if TARGET_IPHONE_SIMULATOR
    if (returnBolck) {
        returnBolck(YES);
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
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
#endif
}
*/
@end
