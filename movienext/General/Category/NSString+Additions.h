//
//  NSString+Additions.h
//  movienext
//
//  Created by 杜承玖 on 14/11/30.
//  Copyright (c) 2014年 redianying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (BOOL)isNotEmpty;
- (NSString*)trim;
- (NSString*)trimBegin:(NSString*)strBegin;
- (NSString*)trimEnd:(NSString*)strEnd;
- (NSString*)trim:(NSString*)strTrim;
- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString*)URLEncodedString;


@end
