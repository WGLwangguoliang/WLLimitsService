# WLLimitsService
系统的一些权限的封装<br/>
首先写了一个block:<br/> 
`
typedef void(^ReturnBlock)(BOOL isOpen);
`
## 一.代码工程
___
### 1.定位服务
<br/>
a.需要导入 `#import <CoreLocation/CoreLocation.h>`<br/>
b.代码方法 `+ (void)isOpenLocationServiceWithBolck:(ReturnBlock)returnBolck;`

### 2.推送消息服务
<br/>
a.需要导入 `#import <UserNotifications/UserNotifications.h>`<br/>
b.代码方法 `+ (void)isOpenMessageNotificationServiceWithBolck:(ReturnBlock)returnBolck;`

### 3.摄像头服务(iOS7以上)
<br/>
a.需要导入 `#import <AVFoundation/AVFoundation.h>`<br/>
b.代码方法 `+ (void)isOpenCaptureDeviceServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(7_0);`

### 4.相册服务
<br/>
a.需要导入 `#import <Photos/Photos.h>#import <AssetsLibrary/AssetsLibrary.h>`<br/>
b.代码方法 `+ (void)isOpenAlbumServiceWithBolck:(ReturnBlock)returnBolck;`

### 5.麦克风服务(iOS8以上)
<br/>
a.需要导入 `#import <AVFoundation/AVFoundation.h>`<br/>
b.代码方法 `+ (void)isOpenRecordServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);`

### 6.通讯录服务
<br/>
a.需要导入 `#import <AddressBook/AddressBook.h>#import <Contacts/Contacts.h>`<br/>
b.代码方法 `+ (void)isOpenContactsServiceWithBolck:(ReturnBlock)returnBolck;`

### 7.蓝牙服务(iOS7以上)
<br/>
a.需要导入 `#import <CoreBluetooth/CoreBluetooth.h>`<br/>
b.代码方法 `+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(7_0);`

### 8.日历/备忘录服务
<br/>
a.需要导入 `#import <EventKit/EventKit.h>`<br/>
b.代码方法 `+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType)entityType;`

### 9.联网服务(iOS9以上)
<br/>
a.需要导入 `#import <CoreTelephony/CTCellularData.h>`<br/>
b.代码方法 `+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(9_0);`

### 10.健康服务(iOS8以上)
<br/>
a.需要导入 `#import <HealthKit/HealthKit.h>`<br/>
b.代码方法 `+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);`

### 11.Touch ID服务(iOS8以上)
<br/>
a.需要导入 `#import <LocalAuthentication/LocalAuthentication.h>`<br/>
b.代码方法 `+ (void)openTouchIDServiceWithBolck:(ReturnBlock)returnBolck NS_AVAILABLE_IOS(8_0);`

## 二.安装
___
1.直接下载工程(有一个.h和.m文件),直接导入就可以了<br/>
2.由于iOS10的权限原因,需要在工程的info.plist(右击选择Open as - Source Code)中添加<br/>
<code>
<!-- 相册 --> 
<key>NSPhotoLibraryUsageDescription</key> 
<string>App需要您的同意,才能访问相册</string> 
<!-- 相机 --> 
<key>NSCameraUsageDescription</key> 
<string>App需要您的同意,才能访问相机</string> 
<!-- 麦克风 --> 
<key>NSMicrophoneUsageDescription</key> 
<string>App需要您的同意,才能访问麦克风</string> 
<!-- 位置 --> 
<key>NSLocationUsageDescription</key> 
<string>App需要您的同意,才能访问位置</string> 
<!-- 在使用期间访问位置 --> 
<key>NSLocationWhenInUseUsageDescription</key> 
<string>App需要您的同意,才能在使用期间访问位置</string> 
<!-- 始终访问位置 --> 
<key>NSLocationAlwaysUsageDescription</key> 
<string>App需要您的同意,才能始终访问位置</string> 
<!-- 日历 --> 
<key>NSCalendarsUsageDescription</key> 
<string>App需要您的同意,才能访问日历</string> 
<!-- 提醒事项 --> 
<key>NSRemindersUsageDescription</key> 
<string>App需要您的同意,才能访问提醒事项</string> 
<!-- 运动与健身 --> 
<key>NSMotionUsageDescription</key> <string>App需要您的同意,才能访问运动与健身</string> 
<!-- 健康更新 --> 
<key>NSHealthUpdateUsageDescription</key> 
<string>App需要您的同意,才能访问健康更新 </string> 
<!-- 健康分享 --> 
<key>NSHealthShareUsageDescription</key> 
<string>App需要您的同意,才能访问健康分享</string> 
<!-- 蓝牙 --> 
<key>NSBluetoothPeripheralUsageDescription</key> 
<string>App需要您的同意,才能访问蓝牙</string> 
<!-- 媒体资料库 --> 
<key>NSAppleMusicUsageDescription</key> 
<string>App需要您的同意,才能访问媒体资料库</string>
</code>