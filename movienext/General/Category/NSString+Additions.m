//
//  NSString+Additions.m
//  movienext
//
//  Created by 杜承玖 on 14/11/30.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(BOOL)isNotEmpty
{
	return [self length] > 0;		
}

-(NSString*)trim
{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)trimBegin:(NSString*)strBegin
{
    if ([strBegin length]==0) {
        return self;
    }
    if ([self hasPrefix:strBegin]) {
        return [self substringFromIndex:[strBegin length]];
    }else
        return self;
}

-(NSString*)trimEnd:(NSString*)strEnd
{
    if ([strEnd length]==0) {
        return self;
    }
    if ([self hasSuffix:strEnd]) {
        return [self substringToIndex:[self length]-[strEnd length]];
    }
    return self;
}
-(NSString*)trim:(NSString*)strTrim
{
    return  [self trimEnd:[self trimBegin:strTrim]];
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

@end
