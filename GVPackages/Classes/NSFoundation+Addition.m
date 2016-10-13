//
//  NSFoundation+Addition.m
//  GVPackages
//
//  Created by Gavin on 16/10/13.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "NSFoundation+Addition.h"
#import "AdditionMacros.h"
#import "GVMath.h"
#import "UIKit+Addition.h"

#pragma mark -
#pragma mark NSObject
@implementation NSObject (Addition)
- (void)tryMethod:(SEL)sel {
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (* func)(id, SEL) = (void *)imp;
        func(self, sel);
    }
}

- (void)tryMethod:(SEL)sel arg:(id)arg {
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (* func)(id, SEL, id) = (void *)imp;
        func(self, sel, arg);
    }
}

- (void)tryMethod:(SEL)sel arg:(id)arg1 arg:(id)arg2 {
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (* func)(id, SEL, id, id) = (void *)imp;
        func(self, sel, arg1, arg2);
    }
    
    //http://stackoverflow.com/questions/12454408/variable-number-of-method-parameters-in-objective-c-need-an-example
    
    
    //http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    
    /*
     In your project Build Settings, under Other Warning Flags (WARNING_CFLAGS), add
     -Wno-arc-performSelector-leaks
     */
}

- (id)nullToNil {
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return self;
    }
}
@end


#pragma mark -
#pragma mark NSString
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
NSString *const kPathFlagRetina = @"@2x";
NSString *const kPathFlagBig = @"Big";
NSString *const kPathFlagHighlighted = @"Hlt";
NSString *const kPathFlagSelected = @"Slt";
#define FileHashDefaultChunkSizeForReadingData 1024*8  //8K

@implementation NSString (Addition)
+ (NSString *)stringWithNumber:(NSInteger)number padding:(int)padding {
    NSString *formater = GVString(@"%%0%id", padding);
    return GVString(formater, number);
}

- (NSString *)pathByAppendingFlag:(NSString *)flag {
    NSString *extension = [self pathExtension];
    NSString *pathBody = [self stringByDeletingPathExtension];
    NSString *newPath = GVString(@"%@%@.%@", pathBody, flag, extension);
    
    return newPath;
}

- (NSString *)join:(NSString *)path {
    return [self stringByAppendingString:path];
}

- (NSString *)joinExt:(NSString *)ext {
    return [self stringByAppendingPathExtension:ext];
}

- (NSString *)joinPath:(NSString *)path {
    return [self stringByAppendingPathComponent:path];
}

- (NSString *)joinPath:(NSString *)path1 path:(NSString *)path2 {
    return [[self joinPath:path1] joinPath:path2];
}
#pragma mark - Time Interval
- (NSTimeInterval)timeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [[formatter dateFromString:timeString] timeIntervalSince1970];
}

- (NSTimeInterval)localTimeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSTimeInterval timeInterval = [self timeIntervalFromString:timeString withDateFormat:format];
    NSUInteger secondsOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    return (timeInterval + secondsOffset);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)deleteLastPathComponent {
    return [self stringByDeletingLastPathComponent];
}

- (NSString *)deletePathExtension {
    return [self stringByDeletingPathExtension];
}

- (BOOL)endWith:(NSString *)string {
    NSUInteger length = string.length;
    if (length==0 || length>self.length) {
        return NO;
    }
    
    NSString *end = [self substringFromIndex:self.length-length];
    return [string isEqualToString:end];
}
-(BOOL)containsString:(NSString *)aString
{
    return ([self rangeOfString:aString].location!=NSNotFound);
}
- (BOOL)beginWith:(NSString *)string {
    NSUInteger length = string.length;
    if (length==0 || length>self.length) {
        return NO;
    }
    
    NSString *begin = [self substringToIndex:length];
    return [string isEqualToString:begin];
}

//+(CGPathRef)pathRefFromText:(NSString *)text animation:(BOOL)animated
//{
//    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:100]}];
//
//    CGMutablePathRef letters = CGPathCreateMutable();
//    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
//    CFArrayRef runArray = CTLineGetGlyphRuns(line);
//    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
//    {
//        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
//        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
//
//        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
//        {
//            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
//            CGGlyph glyph;
//            CGPoint position;
//            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
//            CTRunGetPositions(run, thisGlyphRange, &position);
//
//            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
//            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
//            CGPathAddPath(letters, &t, letter);
//            CGPathRelease(letter);
//        }
//    }
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
//    CGRect boundingBox = CGPathGetBoundingBox(letters);
//    CGPathRelease(letters);
//    CFRelease(line);
//
//
//    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
//    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
//    if (animated) {
//        return [[path bezierPathByReversingPath] CGPath];
//    }
//    return [path CGPath];
//}

+ (NSString*)getMD5WithString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (CC_LONG)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02X", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}
+ (NSString*)getMD5_16WithString:(NSString *)string
{
    // 提取 32 位 MD5 散列的中间 16 位
    
    NSString *md5_32Bit_String=[self getMD5WithString:string];
    
    NSString *result = [[md5_32Bit_String substringToIndex : 24 ] substringFromIndex : 8 ]; // 即 9 ～ 25 位
    
    return result;
    
    
}
+ (NSString*)getMD5WithData:(NSData *)data{
    const char* original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (CC_LONG)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    //也可以定义一个字节数组来接收计算得到的MD5值
    //    Byte byte[16];
    //    CC_MD5(original_str, strlen(original_str), byte);
    //    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    //    for(int  i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
    //        [outPutStr appendFormat:@"%02x",byte[i]];
    //    }
    //    [temp release];
    
    return [outPutStr lowercaseString];
    
}
//是否为数据库中的空值
+(BOOL) isDBNull:(id)value{
    return value == [NSNull null];
}

//将数据库值转为字符，防止出现NSNull
+(NSString *) valueToString:(id)value{
    return [self isDBNull: value] ? nil : value;
}

//将数据库中的值转换为日期
+(NSDate*) valueToDate:(id)value
{
    if([self isDBNull: value]) return nil;
    //如果是数字的话，则使用dateWithTimeIntervalSince1970转换
    if([value isMemberOfClass:NSClassFromString(@"__NSCFNumber")]){
        return [NSDate dateWithTimeIntervalSince1970: [value doubleValue]];
    }else if([value isMemberOfClass:[NSString class]]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        return [dateFormatter dateFromString: value];
    }
    
    return nil;
}

//将日期转换为数字，因为sqlite不支持数据库
+(id) dateToValue: (NSDate *) date{
    if(date == nil) return [NSNull null];
    return  [NSNumber numberWithDouble: [date timeIntervalSince1970]];
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

- (NSString *)decodeHTMLCharacterEntities {
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unichar)(160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unichar)tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unichar)[value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)encodeHTMLCharacterEntities {
    NSMutableString *encoded = [NSMutableString stringWithString:self];
    
    // @"&amp;"
    NSRange range = [self rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [self rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [self rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    return encoded;
}
+ (NSString *)StringEncode:(NSString*)str
{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[str UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
+ (NSString *)StringDecode:(NSString*)str
{
    return [[str stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)URLEncode:(NSString*)baseUrl data:(NSDictionary*)dictionary
{
    NSString *url = baseUrl;
    if(url.length > 0)
    {
        url = [url stringByAppendingString:@"?"];
    }
    
    BOOL isFirst = YES;
    for(NSString *key in dictionary.allKeys)
    {
        if(isFirst)
        {
            isFirst = NO;
        }
        else
        {
            url = [url stringByAppendingString:@"&"];
        }
        url = [url stringByAppendingFormat:@"%@=%@", [self StringEncode:key], [self StringEncode:[dictionary objectForKey:key]]];
    }
    return url;
}

+ (NSArray *)URLDecode:(NSString *)url
{
    NSRange range = [url rangeOfString:@"?"];
    if(range.location == NSNotFound)
    {
        return @[url, [NSNull null]];
    }
    
    NSString *baseUrl = [url substringToIndex:range.location - 1];
    NSString *dataUrl = [url substringFromIndex:range.location + 1];
    
    NSArray *parameters = [dataUrl componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    for(NSString *pa in parameters)
    {
        NSArray *pair = [pa componentsSeparatedByString:@"="];
        NSString *key = [self StringDecode:[pair objectAtIndex:0]];
        NSString *val = [self StringDecode:[pair objectAtIndex:1]];
        
        [dic setValue:val forKey:key];
    }
    return @[baseUrl, dic];
}

@end

#pragma mark -
#pragma mark NSDate
@implementation NSDate (Addition)
+ (NSDate *)dateWithinYear {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = arc4random_uniform(60 * 60 * 24 * 360);
    
    NSDate *date = [today dateByAddingTimeInterval:-interval];
    
    return date;
}

+ (NSDate *)dateWithTimeIntervalSince1970Number:(NSNumber *)number {
    NSTimeInterval timeInterval = [number doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

+ (NSDate *)dateWithTimeIntervalSince1970String:(NSString *)string {
    NSTimeInterval timeInterval = [string doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

+ (NSDate *)dateWithString:(NSString *)date template:(NSString *)template {
    if (!date || !template) {
        return nil;
    }
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    dateFormatter.dateFormat = template;
    return [dateFormatter dateFromString:date];
}

- (NSString *)stringWithTemplate:(NSString *)template {
    if(!template) return nil;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    //    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //    NSString *dateString = [NSDateFormatter dateFormatFromTemplate:tmplate options:0 locale:usLocale];
    dateFormatter.dateFormat = template;
    return [dateFormatter stringFromDate:self];
}

- (BOOL)isSameDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp1 = [calendar components:GVCOMPS_DATE fromDate: self];
    NSDateComponents *comp2 = [calendar components:GVCOMPS_DATE fromDate: date];
    return comp1.year==comp2.year && comp1.month==comp2.month && comp1.day==comp2.day;
}

- (NSString *)timeIntervalSince1970String {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSString *timeString = GVString(@"%f", timeInterval);
    return timeString;
}
+(NSString*)timeFlagString:(NSDate *)date
{
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha = now - late;
    
    if (cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if ([timeString integerValue]<=5) {
            timeString = @"刚刚";
        }else{
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha / 3600 > 1 && cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date]];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        if([timeString integerValue] < 3){
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
        }else{
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"MM-dd"];
            timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date]];
        }
    }
    if (cha/(86400*365)>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date]];
    }
    return timeString;
}

- (NSNumber *)timeIntervalSince1970Number {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return @(timeInterval);
}
@end

#pragma mark -
#pragma mark NSMutableDictionary
@implementation NSMutableDictionary (Addition)
- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key {
    if (key && obj) {
        [self setObject:obj forKey:key];
    }
}
@end






#pragma mark -
#pragma mark NSArray
@implementation NSArray (Addition)
- (id)safeObjectAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.count) {
        return nil;
    } else return self[index];
}
@end






#pragma mark -
#pragma mark NSMutableArray
@implementation NSMutableArray (Addition)
- (void)safeAddObject:(id)obj {
    if (obj) {
        [self addObject:obj];
    }
}
@end






#pragma mark -
#pragma mark NSAttributedString
#define JSON_STYLE_KEY          @"style"
#define JSON_WIDTH_KEY          @"width"
#define JSON_COLOR_KEY          @"color"
#define JSON_RANGE_KEY          @"range"
#define JSON_STRING_KEY         @"string"
#define JSON_VALUE_KEY          @"value"
#define JSON_ATTRIBUTE_KEY      @"attribute"
#define JSON_LIGATURE_KEY       @"ligature"
#define JSON_KERN_KEY           @"kern"
#define JSON_EFFECT_KEY         @"effect"
#define JSON_LINK_KEY           @"link"
#define JSON_OFFSET_KEY         @"offset"
#define JSON_OBLIQUENESS_KEY    @"obliqueness"
#define JSON_EXPANSION_KEY      @"expansion"
#define JSON_DIRECTION_KEY      @"direction"
#define JSON_GLYPH_KEY          @"glyph"
#define JSON_RADIUS_KEY         @"radius"
#define JSON_ALIGNMENT_KEY      @"alignment"
#define JSON_INDENT_FIRST_LINE_HEAD_KEY @"firstLineHeadIndent"
#define JSON_INDENT_HEAD_KEY            @"headIndent"
#define JSON_INDENT_TAIL_KEY            @"tailIndent"
#define JSON_LINE_BREAKING_MODE_KEY     @"lineBreakingMode"
#define JSON_LINE_HEIGHT_MULTIPLE_KEY   @"lineHeightMultiple"
#define JSON_LINE_HEIGHT_MAX_KEY        @"lineHeightMax"
#define JSON_LINE_HEIGHT_MIN_KEY        @"lineHeightMin"
#define JSON_SPACING_LINE_KEY               @"lineSpacing"
#define JSON_SPACING_PARAGRAPH_KEY          @"paragraphSpacing"
#define JSON_SPACING_PARAGRAPH_BEFORE_KEY   @"paragraphSpacingBefore"
#define JSON_BASE_WRITING_DIRECTION_KEY     @"baseWritingDirection"
#define JSON_HYPHENATION_FACTOR_KEY         @"hyphenationFactor"

@implementation NSAttributedString (Addition)
+ (instancetype)stringWithJSONString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return [self stringWithJSON:json];
}

+ (instancetype)stringWithJSON:(id)json {
    if(!GVJSONIsDictionary(json)) return nil;
    NSString *string = json[JSON_STRING_KEY];
    NSDictionary *dicAttribute = json[JSON_ATTRIBUTE_KEY];
    return [self stringWithString:string jsonAttribute:dicAttribute];
}

+ (instancetype)stringWithString:(NSString *)string attribute:(NSString *)attribute {
    NSAttributedString *attributedString = nil;
    if (attribute.length > 0) {
        NSData *data = [attribute dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        attributedString =  [self stringWithString:string jsonAttribute:json];
    } else {
        attributedString = [[NSAttributedString alloc] initWithString:string];
    }
    
    return attributedString;
}


+ (instancetype)stringWithString:(NSString *)string jsonAttribute:(NSDictionary *)attribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attribute enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *attributeName = (NSString *)key;
        NSArray *arrAttribute = (NSArray *)obj;
        [arrAttribute enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dicPair = (NSDictionary *)obj; //attribute value & range
            
            //range
            NSString *strRange = dicPair[JSON_RANGE_KEY];
            NSRange range = NSRangeFromString(strRange);
            
            //value
            NSDictionary *dicValue = dicPair[JSON_VALUE_KEY];
            if (dicValue.count > 0) {
                id value = nil;
                
                if ([attributeName isEqualToString:NSFontAttributeName]) {
                    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:dicValue];
                    value = [UIFont fontWithDescriptor:descriptor size:-1];
                    
                } else if ([attributeName isEqualToString:NSParagraphStyleAttributeName]) {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    id styleValue = nil;
                    
                    styleValue = dicValue[JSON_LINE_HEIGHT_MULTIPLE_KEY];
                    if (styleValue) {
                        paragraphStyle.lineHeightMultiple = [styleValue floatValue];
                    }
                    
                    styleValue = dicValue[JSON_LINE_HEIGHT_MAX_KEY];
                    if (styleValue) {
                        paragraphStyle.maximumLineHeight = [styleValue floatValue];
                    }
                    
                    styleValue = dicValue[JSON_SPACING_PARAGRAPH_BEFORE_KEY];
                    if (styleValue) {
                        paragraphStyle.paragraphSpacingBefore = [styleValue floatValue];
                    }
                    
                    styleValue = dicValue[JSON_HYPHENATION_FACTOR_KEY];
                    if (styleValue) {
                        paragraphStyle.hyphenationFactor = [styleValue floatValue];
                    }
                    
                    paragraphStyle.alignment = (NSTextAlignment)[dicValue[JSON_ALIGNMENT_KEY] integerValue];
                    paragraphStyle.firstLineHeadIndent = [dicValue[JSON_INDENT_FIRST_LINE_HEAD_KEY] floatValue];
                    paragraphStyle.headIndent = [dicValue[JSON_INDENT_HEAD_KEY] floatValue];
                    paragraphStyle.tailIndent = [dicValue[JSON_INDENT_TAIL_KEY] floatValue];
                    paragraphStyle.lineBreakMode = (NSLineBreakMode)[dicValue[JSON_LINE_BREAKING_MODE_KEY] integerValue];
                    paragraphStyle.minimumLineHeight = [dicValue[JSON_LINE_HEIGHT_MIN_KEY] floatValue];
                    paragraphStyle.lineSpacing = [dicValue[JSON_SPACING_LINE_KEY] floatValue];
                    paragraphStyle.paragraphSpacing = [dicValue[JSON_SPACING_PARAGRAPH_KEY] floatValue];
                    paragraphStyle.baseWritingDirection = (NSWritingDirection)[dicValue[JSON_BASE_WRITING_DIRECTION_KEY] integerValue];
                    
                    value = (NSParagraphStyle *)paragraphStyle;
                    
                } else if ([attributeName isEqualToString:NSForegroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSBackgroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSStrokeColorAttributeName]       ||
                           [attributeName isEqualToString:NSUnderlineColorAttributeName]    ||
                           [attributeName isEqualToString:NSStrikethroughColorAttributeName]) {
                    NSString *colorString = dicValue[JSON_COLOR_KEY];
                    value = [UIColor colorWithString:colorString];
                    
                } else if ([attributeName isEqualToString:NSLigatureAttributeName]) {
                    value = dicValue[JSON_LIGATURE_KEY]; //value is a NSNumber
                    
                } else if ([attributeName isEqualToString:NSKernAttributeName]) {
                    value = dicValue[JSON_KERN_KEY]; //value is a NSNumber
                    
                } else if ([attributeName isEqualToString:NSStrikethroughStyleAttributeName]) {
                    value = dicValue[JSON_STYLE_KEY]; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSUnderlineStyleAttributeName]) {
                    value = dicValue[JSON_STYLE_KEY]; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSStrokeWidthAttributeName]) {
                    value = dicValue[JSON_WIDTH_KEY]; //value is a NSNumber
                    
                } else if ([attributeName isEqualToString:NSShadowAttributeName]) {
                    //value is a NSShadow
                    NSShadow *shadow = [[NSShadow alloc] init];
                    id shadowValue = nil;
                    
                    shadowValue = dicValue[JSON_OFFSET_KEY];
                    if (shadowValue) {
                        shadow.shadowOffset = CGSizeFromString(shadowValue);
                    }
                    
                    shadowValue = dicValue[JSON_RADIUS_KEY];
                    if (shadowValue) {
                        shadow.shadowBlurRadius = [shadowValue floatValue];
                    }
                    
                    shadowValue = dicValue[JSON_COLOR_KEY];
                    if (shadowValue) {
                        shadow.shadowColor = [UIColor colorWithString:shadowValue];
                    }
                    
                } else if ([attributeName isEqualToString:NSTextEffectAttributeName]) {
                    //value is an NSString
                    value = dicValue[JSON_EFFECT_KEY];
                    
                } else if ([attributeName isEqualToString:NSAttachmentAttributeName]) {
                    //todo: value is an NSTextAttachment
                    
                } else if ([attributeName isEqualToString:NSLinkAttributeName]) {
                    //value is a url NSString
                    value = dicValue[JSON_LINK_KEY];
                    
                } else if ([attributeName isEqualToString:NSBaselineOffsetAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_LINK_KEY];
                    
                } else if ([attributeName isEqualToString:NSObliquenessAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_OBLIQUENESS_KEY];
                    
                } else if ([attributeName isEqualToString:NSExpansionAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_EXPANSION_KEY];
                    
                } else if ([attributeName isEqualToString:NSWritingDirectionAttributeName]) {
                    //value is an NSArray of several NSNumber
                    value = dicValue[JSON_DIRECTION_KEY];
                    
                } else if ([attributeName isEqualToString:NSVerticalGlyphFormAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_GLYPH_KEY];
                    
                }
                
                if (value) {
                    [attributedString addAttribute:attributeName value:value range:range];
                }
            }
        }];
    }];
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}


- (NSString *)jsonString {
    id json = [self dumpJSON];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

- (id)dumpJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    //string
    GVMDictionaryAdd(json, JSON_STRING_KEY, self.string);
    
    //attribute
    id dicAttribute = [self attributeJSON];
    GVMDictionaryAdd(json, JSON_ATTRIBUTE_KEY, dicAttribute);
    
    return json;
}

- (NSString *)attributeString {
    id json = [self attributeJSON];
    
    //NSData *data = [NSPropertyListSerialization dataFromPropertyList:json format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

- (id)attributeJSON {
    static NSArray * arrAttributeName = nil;
    if (!arrAttributeName) {
        arrAttributeName = @[NSFontAttributeName,               NSParagraphStyleAttributeName,
                             NSForegroundColorAttributeName,    NSBackgroundColorAttributeName,
                             NSStrokeColorAttributeName,        NSStrikethroughColorAttributeName,
                             NSUnderlineColorAttributeName,     NSLigatureAttributeName,
                             NSKernAttributeName,               NSStrikethroughStyleAttributeName,
                             NSUnderlineStyleAttributeName,     NSStrokeWidthAttributeName,
                             NSShadowAttributeName,             NSTextEffectAttributeName,
                             NSAttachmentAttributeName,         NSLinkAttributeName,
                             NSBaselineOffsetAttributeName,     NSObliquenessAttributeName,
                             NSExpansionAttributeName,          NSWritingDirectionAttributeName,
                             NSVerticalGlyphFormAttributeName];
    }
    NSMutableDictionary *dicAttribute = [NSMutableDictionary dictionary];
    
    NSRange wholeRange = NSMakeRange(0, self.string.length);
    for (NSString *attributeName in arrAttributeName) {
        NSMutableArray *arrValue = [NSMutableArray array];
        [self enumerateAttribute:attributeName inRange:wholeRange options:NSAttributedStringEnumerationReverse usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                //value
                NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
                if ([attributeName isEqualToString:NSFontAttributeName]) {
                    //value is a UIFont
                    UIFont *font = (UIFont *)value;
                    UIFontDescriptor *descriptor = font.fontDescriptor;
                    [dicValue addEntriesFromDictionary:descriptor.fontAttributes];
                    
                } else if ([attributeName isEqualToString:NSParagraphStyleAttributeName]) {
                    //value is an NSParagraphStyle
                    if ([value isKindOfClass:[NSParagraphStyle class]]) {
                        NSParagraphStyle *paragraphStyle = (NSParagraphStyle *)value;
                        
                        if (paragraphStyle.lineHeightMultiple != 0.0) {
                            dicValue[JSON_LINE_HEIGHT_MULTIPLE_KEY] = @(paragraphStyle.lineHeightMultiple);
                        }
                        if (paragraphStyle.maximumLineHeight != 0.0) {
                            dicValue[JSON_LINE_HEIGHT_MAX_KEY] = @(paragraphStyle.maximumLineHeight);
                        }
                        if (paragraphStyle.paragraphSpacingBefore != 0.0) {
                            dicValue[JSON_SPACING_PARAGRAPH_BEFORE_KEY] = @(paragraphStyle.paragraphSpacingBefore);
                        }
                        if (paragraphStyle.hyphenationFactor != 0.0) {
                            dicValue[JSON_HYPHENATION_FACTOR_KEY] = @(paragraphStyle.hyphenationFactor);
                        }
                        
                        //todo: tab stops
                        
                        dicValue[JSON_ALIGNMENT_KEY]                = @(paragraphStyle.alignment);
                        dicValue[JSON_INDENT_FIRST_LINE_HEAD_KEY]   = @(paragraphStyle.firstLineHeadIndent);
                        dicValue[JSON_INDENT_HEAD_KEY]              = @(paragraphStyle.headIndent);
                        dicValue[JSON_INDENT_TAIL_KEY]              = @(paragraphStyle.tailIndent);
                        dicValue[JSON_LINE_BREAKING_MODE_KEY]       = @(paragraphStyle.lineBreakMode);
                        dicValue[JSON_LINE_HEIGHT_MIN_KEY]          = @(paragraphStyle.minimumLineHeight);
                        dicValue[JSON_SPACING_LINE_KEY]             = @(paragraphStyle.lineSpacing);
                        dicValue[JSON_SPACING_PARAGRAPH_KEY]        = @(paragraphStyle.paragraphSpacing);
                        dicValue[JSON_BASE_WRITING_DIRECTION_KEY]   = @(paragraphStyle.baseWritingDirection);
                    }
                    
                } else if ([attributeName isEqualToString:NSForegroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSBackgroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSUnderlineColorAttributeName]    ||
                           [attributeName isEqualToString:NSStrokeColorAttributeName]       ||
                           [attributeName isEqualToString:NSStrikethroughColorAttributeName]) {
                    UIColor *color = (UIColor *)value;
                    dicValue[JSON_COLOR_KEY] = color.string;
                    
                } else if ([attributeName isEqualToString:NSLigatureAttributeName]) {
                    dicValue[JSON_LIGATURE_KEY] = value; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSKernAttributeName]) {
                    dicValue[JSON_KERN_KEY] = value; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSStrikethroughStyleAttributeName]) {
                    dicValue[JSON_STYLE_KEY] = value; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSUnderlineStyleAttributeName]) {
                    dicValue[JSON_STYLE_KEY] = value; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSStrokeWidthAttributeName]) {
                    dicValue[JSON_WIDTH_KEY] = value; //NSNumber
                    
                } else if ([attributeName isEqualToString:NSShadowAttributeName]) {
                    //value is an NSShadow
                    if ([value isKindOfClass:[NSShadow class]]) {
                        NSShadow *shadow = (NSShadow *)value;
                        GVMDictionaryAdd(dicValue, JSON_OFFSET_KEY, NSStringFromCGSize(shadow.shadowOffset));
                        GVMDictionaryAdd(dicValue, JSON_RADIUS_KEY, @(shadow.shadowBlurRadius));
                        if ([shadow.shadowColor isKindOfClass:[UIColor class]]) {
                            dicValue[JSON_COLOR_KEY] = [(UIColor *)shadow.shadowColor string];
                        }
                    }
                    
                } else if ([attributeName isEqualToString:NSTextEffectAttributeName]) {
                    //value is an NSString
                    dicValue[JSON_EFFECT_KEY] = value;
                    
                } else if ([attributeName isEqualToString:NSAttachmentAttributeName]) {
                    //todo: value is an NSTextAttachment
                    
                } else if ([attributeName isEqualToString:NSLinkAttributeName]) {
                    //value is an NSURL or NSString
                    if ([value isKindOfClass:[NSString class]]) {
                        dicValue[JSON_LINK_KEY] = value;
                    } else if ([value isKindOfClass:[NSURL class]]) {
                        NSString *url = [(NSURL *)value absoluteString];
                        if (url) {
                            dicValue[JSON_LINK_KEY] = url;
                        }
                    }
                } else if ([attributeName isEqualToString:NSBaselineOffsetAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_OFFSET_KEY] = value;
                    
                } else if ([attributeName isEqualToString:NSObliquenessAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_OBLIQUENESS_KEY] = value;
                    
                } else if ([attributeName isEqualToString:NSExpansionAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_EXPANSION_KEY] = value;
                    
                } else if ([attributeName isEqualToString:NSWritingDirectionAttributeName]) {
                    //value is an NSAray of several NSNumber
                    dicValue[JSON_DIRECTION_KEY] = value;
                    
                } else if ([attributeName isEqualToString:NSVerticalGlyphFormAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_GLYPH_KEY] = value;
                    
                }
                
                if (dicValue.count > 0) {
                    NSMutableDictionary *dicPair = [NSMutableDictionary dictionary]; //attribute value & range
                    
                    //value
                    dicPair[JSON_VALUE_KEY] = dicValue;
                    //range
                    dicPair[JSON_RANGE_KEY] = NSStringFromRange(range);
                    
                    //add value&range pair to array
                    GVMArrayAdd(arrValue, dicPair);
                }
            }
        }];
        if (arrValue.count > 0) {
            GVMDictionaryAdd(dicAttribute, attributeName, arrValue);
        }
    }
    
    return dicAttribute;
}
@end;

#pragma mark -
#pragma mark NSMutableAttributedString
@implementation NSMutableAttributedString (Addition)
- (NSAttributedString *)underlineAttributeString {
    static NSDictionary *underlineAttribute = nil;
    if (!underlineAttribute) {
        underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    }
    [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, self.length)];
    return self;
}
@end;













