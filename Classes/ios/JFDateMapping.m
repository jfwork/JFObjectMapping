//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFDateMapping.h"

@interface JFDateMapping ()

@property(nonatomic, retain) __block NSDateFormatter *formatter;

@end

@implementation JFDateMapping

- (id)initWithFieldName:(NSString *)fieldName andTargetClass:(Class)clazz
{
    self = [super initWithFieldName:fieldName andTargetClass:clazz];
    if (self) {
        self.formatter = [NSDateFormatter new];
        __block id this = self;
        self.mappingBlock = ^id(id value, BOOL inverse) {
            if (!inverse) {
                return [this parse:value];
            }
            else {
                return [this convert:value];
            }
        };
    }

    return self;
}

- (id)convert:(id)value
{
    NSDate *date = value;
    if ([value isKindOfClass:[NSDate class]] && self.format == nil) {
        long long int result = (long long int)date.timeIntervalSince1970 * 1000;
        return @(result);
    }
    else {
        return [self.formatter dateFromString:value];
    }
}

- (id)parse:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
                NSNumber *number = value;
                double millis = (number.doubleValue + 999) / 1000;
                return [NSDate dateWithTimeIntervalSince1970:millis];
            }
    return [self.formatter dateFromString:value];
}

- (void)setFormat:(NSString *)format
{
    _format = format;
    if (format.length) {
        self.formatter.dateFormat = format;
    }
}


@end