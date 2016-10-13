//
//  Addition.h
//  GVPackages
//
//  GVeated by Gavin on 16/10/13.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#ifndef Addition_h
#define Addition_h

#pragma mark -
#pragma mark Hardware & OS

#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#define __weak_delegate __weak
#else
#define weak_delegate unsafe_unretained
#define __weak_delegate __unsafe_unretained
#endif


#pragma mark -
#pragma mark foundation
//==================object==================
#define GVNull [NSNull null]
//==================string==================
#define GVString(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define GVStringNum(number) GVString(@"%ld", (long)number)
#define $str(...)   [NSString stringWithFormat:__VA_ARGS__]
//==================array==================
#define GVMArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
//==================date==================
#define GVCOMPS_DATE NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define GVCOMPS_TIME NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
//==================range==================
#define GVRangeZero NSMakeRange(0, 0)



#pragma mark -
#pragma mark notification
#define GVRegisterNotification(sel, nam)            GVRegisterNotification3(sel, nam, nil)
#define GVRegisterNotification3(sel, nam, obj)      GVRegisterNotification4(self, sel, nam, obj)
#define GVRegisterNotification4(obs, sel, nam, obj) [[NSNotificationCenter defaultCenter] addObserver:obs selector:sel name:nam object:obj]
#define GVUnregisterNotification(obs)               GVUnregisterNotification2(obs, nil)
#define GVUnregisterNotification2(obs, nam)         GVUnregisterNotification3(obs, nam, nil)
#define GVUnregisterNotification3(obs, nam, obj)    [[NSNotificationCenter defaultCenter] removeObserver:obs name:nam object:obj]
#define GVPostNotification(name)                    GVPostNotification2(name, nil)
#define GVPostNotification2(name, obj)              GVPostNotification3(name, obj, nil)
#define GVPostNotification3(name, obj, info)        [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]


#pragma mark -
#pragma mark image
//==================image==================
#define GVImageNamed(name)         [UIImage imageNamed:name]
#define GVImageFormated(fmt, ...)  GVImageNamed(GVString(fmt, ##__VA_ARGS__))
#define GVImageFiled(path)         [UIImage imageWithContentsOfFile:path]
#define GVImageViewNamed(name)     [[UIImageView alloc] initWithImage:GVImageNamed(name)]
#define GVImageViewFormated(fmt,...)  [[UIImageView alloc] initWithImage:GVImageFormated(fmt, ##__VA_ARGS__)]
#define GVImageViewFiled(path)        [[UIImageView alloc] initWithImage:GVImageFiled(path)]


#pragma mark -
#pragma mark device
//==================model==================

#define SGScreenScale [UISGVeen mainSGVeen].scale

#define GVKeyWindow [UIApplication sharedApplication].keyWindow

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//application status
#define GVAPP_IN_BACKGROUND (GVSharedApp.applicationState==UIApplicationStateBackground)
#define GVDisableAppIdleTimer(flag) GVSharedApp.idleTimerDisabled=(flag)

//==================network==================
#define GVDisplayNetworkIndicator(flag) [GVSharedApp setNetworkActivityIndicatorVisible:(flag)]



#pragma mark -
#pragma mark system
//==================system version==================
#define GVOSVersionEqualTo(v)           ([[GVCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define GVOSVersionGreaterThan(v)       ([[GVCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define GVOSVersionNotLessThan(v)       ([[GVCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define GVOSVersionLessThan(v)          ([[GVCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define GVOSVersionNotGreaterThan(v)    ([[GVCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define GVAppDisplayName                [GVBundle infoDictionary][@"CFBundleDisplayName"]
#define GVAppBuild                      [GVBundle infoDictionary][(NSString *)kCFBundleVersionKey]
#define GVAppVersionShort               [GVBundle infoDictionary][@"CFBundleShortVersionString"]


#pragma mark -
#pragma mark App Default
#define GVSharedApp             [UIApplication sharedApplication]
#define GVAppDelegate           [GVSharedApp delegate]
#define GVNotificationCenter    [NSNotificationCenter defaultCenter]
#define GVCurrentDevice         [UIDevice currentDevice]
#define GVBundle                [NSBundle mainBundle] //the main bundle
#define GVMainSGVeen            [UISGVeen mainSGVeen]
#define GVCurrentLanguage       [NSLocale preferredLanguages][0]
#define GVSGVeenScaleFactor     [GVMainSGVeen scale]
#define GVFileMgr               [NSFileManager defaultManager]

//==================user defaults==================
#define GVUserDefaults              [NSUserDefaults standardUserDefaults]
#define GVUserObj(key)              [GVUserDefaults objectForKey:(key)]
#define GVUserBOOL(key)             [GVUserDefaults boolForKey:(key)]
#define GVUserInteger(key)          [GVUserDefaults integerForKey:(key)]
#define GVUserSetObj(obj, key)      [GVUserDefaults setObject:(obj) forKey:(key)]
#define GVUserSetInteger(i, key)    [GVUserDefaults setObject:@(i) forKey:(key)]
#define GVUserSetBOOL(boo, key)     [GVUserDefaults setBool:boo forKey:(key)]
#define GVUserRemoveObj(key)        [GVUserDefaults removeObjectForKey:(key)]




#pragma mark -
#pragma mark GCD
//==================block==================
#define GVBackgroundGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GVMainGCD(block)       dispatch_async(dispatch_get_main_queue(), block)
#define GVWeekRef(obj)         __weak typeof(obj) __##obj = obj
#define GVBlockRef(obj)        __block typeof(obj) __##obj = obj
typedef void(^CallbackTask)(void);

//==================selector==================
#define GVIfReturn(con)     if(con) return
#define GVNilReturn(obj)    if(!obj) return
#define GVReturnNil         return nil;
#define SELE(sel)           @selector(sel)

//==================singleton==================
#ifndef GVSingleton
#define GVSingleton(classname, method)                      \
+ (classname *)shared##method {                             \
static dispatch_once_t pred;                            \
__strong static classname *shared##classname = nil;     \
dispatch_once(&pred, ^{                                 \
shared##classname = [[self alloc] init];            \
});                                                     \
return shared##classname;                               \
}
#endif

#define GVManager(classname) GVSingleton(classname, Manager)



#pragma mark -
#pragma mark color
//==================color==================
#define GVCOLOR_CLEAR           [UIColor clearColor]
#define GVCOLOR_WHITE           [UIColor whiteColor]
#define GVCOLOR_BLACK           [UIColor blackColor]
#define GVCOLOR_RED             [UIColor redColor]
#define GVCOLOR_BACKGROUND      [UIColor colorFromHexRGB:@"dedede"]
#define GVColorPattern(name)    [UIColor colorWithPatternImage:UIIMAGE_NAMED(name)]

//r, g, b range from 0 - 1.0
#define GVRGB_F(r,g,b)     GVRGBA_F(r, g, b, 1.0)
#define GVRGBA_F(r,g,b,a)  [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
//r, g, b range from 0 - 255
#define GVRGB(r,g,b)       GVRGBA(r, g, b, 1.0)
#define GVRGBA(r,g,b,a)    GVRGBA_F((r)/255.f, (g)/255.f,(b)/255.f, a)
//rgbValue is a Hex vaule without prefix 0x
#define GVRGB_X(rgb)       GVRGBA_X(rgb, 1.0)
#define GVRGBA_X(rgb, a)   GVRGBA((float)((0x##rgb & 0xFF0000) >> 16), (float)((0x##rgb & 0xFF00) >> 8), (float)(0x##rgb & 0xFF), (a))




#pragma mark -
#pragma mark log
//==================log==================
#ifndef __OPTIMIZE__
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


#ifdef DEBUG //debug
#   define GVLog(fmt, ...) NSLog((@"%@->%@ <Line %d>: " fmt), NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, ##__VA_ARGS__)

#   define _ptp(point) DLOG(@"CGPoint: {%.0f, %.0f}", (point).x, (point).y)
#   define _pts(size) DLOG(@"CGSize: {%.0f, %.0f}", (size).width, (size).height)
#   define _ptr(rect) DLOG(@"CGRect: {{%.1f, %.1f}, {%.1f, %.1f}}", (rect).origin.x, (rect).origin.y, (rect).size.width, (rect).size.height)
#   define _pto(obj) DLOG(@"object %s: %@", #obj, [(obj) desGViption])
#   define _ptb(boo) DLOG(@"boolean value %s: %@", #boo, boo?@"YES":@"NO")
#   define _pti(i) DLOG(@"integer value %s: %ld", #i, (long)i)
#   define _ptm    NSLog(@"\nmark called %s, at line %d", __PRETTY_FUNCTION__, __LINE__)
#   define _if(con)     if(con) NSLog(@"\ncondition matched %s, at line %d", __PRETTY_FUNCTION__, __LINE__)

#   define ULOG(fmt, ...)  { \
NSString *title = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]; \
NSString *msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__];     \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title       \
message:msg         \
delegate:nil         \
cancelButtonTitle:@"OK"       \
otherButtonTitles:nil];       \
[alert show]; \
}
#else //release
#   define GVLog(...)
#   define ULOG(...)
#   define _ptp(point)
#   define _pts(size)
#   define _ptr(rect)
#   define _ptb(boo)
#   define _pti(i)
#   define _pto(obj)
#   define _ptm
#   define _if(con)
#endif
#endif /* Addition_h */
