//
//  NSFoundation+Addition.h
//  GVPackages
//
//  Created by Gavin on 16/10/13.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark NSObject
@interface NSObject (Addition)
- (void)tryMethod:(SEL)sel;
- (void)tryMethod:(SEL)sel arg:(id)arg;
- (void)tryMethod:(SEL)sel arg:(id)arg1 arg:(id)arg2;
- (id)nullToNil;
@end

#pragma mark -
#pragma mark NSString
extern NSString *const kPathFlagRetina;
extern NSString *const kPathFlagBig;
extern NSString *const kPathFlagHighlighted;
extern NSString *const kPathFlagSelected;

@interface NSString (Addition)
+ (NSString *)stringWithNumber:(NSInteger)number padding:(int)padding;
- (NSString *)pathByAppendingFlag:(NSString *)flag; //appending between file name and extension
- (NSString *)join:(NSString *)path;
- (NSString *)joinExt:(NSString *)ext;
- (NSString *)joinPath:(NSString *)path;
- (NSString *)joinPath:(NSString *)path1 path:(NSString *)path2;
- (NSString *)deleteLastPathComponent;
- (NSString *)deletePathExtension;
- (BOOL)beginWith:(NSString *)string;
- (BOOL)endWith:(NSString *)string;
- (BOOL)containsString:(NSString *)aString;

//#pragma --mark Path
//+(CGPathRef)pathRefFromText:(NSString *)text animation:(BOOL)animated;

#pragma --mark MD5
+(NSString*)getMD5WithData:(NSData*)data;
+(NSString*)getMD5WithString:(NSString*)string;
+ (NSString*)getMD5_16WithString:(NSString *)string;
+(NSString*)getFileMD5WithPath:(NSString*)path;

#pragma --mark CodeHTML
- (NSString *)decodeHTMLCharacterEntities;
- (NSString *)encodeHTMLCharacterEntities;

#pragma --mark URLEncode
+ (NSString *)StringEncode:(NSString*)str;
+ (NSString *)StringDecode:(NSString*)str;
+ (NSString *)URLEncode:(NSString*)baseUrl data:(NSDictionary*)dictionary;
+ (NSArray *)URLDecode:(NSString *)url;
@end

#pragma --mark NSDate
@interface NSDate (Addition)
+ (NSDate *)dateWithinYear;
+ (NSDate *)dateWithTimeIntervalSince1970Number:(NSNumber *)number;
+ (NSDate *)dateWithTimeIntervalSince1970String:(NSString *)string;
+ (NSDate *)dateWithString:(NSString *)date template:(NSString *)tmplate;
+ (NSString*)timeFlagWithDate:(NSDate*)date;
- (NSString *)stringWithTemplate:(NSString *)tmplate;
- (NSString *)timeIntervalSince1970String;
- (NSNumber *)timeIntervalSince1970Number;
- (BOOL)isSameDay:(NSDate *)date;
@end

#pragma mark -
#pragma mark NSMutableDictionary
@interface NSMutableDictionary (Addition)
- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key;
@end


#pragma mark -
#pragma mark NSMutableArray
@interface NSArray (Addition)
- (id)safeObjectAtIndex:(NSInteger)index;
@end

#pragma mark -
#pragma mark NSMutableArray
@interface NSMutableArray (Addition)
- (void)safeAddObject:(id)obj;
@end

#pragma mark -
#pragma mark NSAttributedString
@interface NSAttributedString (Addition)
+ (instancetype)stringWithJSON:(id)json;
+ (instancetype)stringWithJSONString:(NSString *)string;
+ (instancetype)stringWithString:(NSString *)string attribute:(NSString *)attribute;
- (id)dumpJSON;
- (id)attributeJSON; //dump only the attribte to json
- (NSString *)jsonString;
- (NSString *)attributeString; //json like
@end;


#pragma mark -
#pragma mark NSMutableAttributedString
@interface NSMutableAttributedString (Addition)
- (NSAttributedString *)underlineAttributeString;
@end

