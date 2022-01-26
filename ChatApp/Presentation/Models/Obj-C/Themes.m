//
//  Themes.m
//  ChatApp
//
//  Created by Valeria Muldt on 12.10.2021.
//

#import <UIKit/UIKit.h>
#import "Themes.h"

@implementation Themes

@synthesize theme1 = _theme1;

- (void)setTheme1:(UIColor *)theme1 {
    [theme1 retain];
    [_theme1 release];
    _theme1 = theme1;
};

- (UIColor *)theme1 {
    return _theme1;
};

@synthesize theme2 = _theme2;

- (void)setTheme2:(UIColor *)theme2 {
    [theme2 retain];
    [_theme2 release];
    _theme2 = theme2;
};

- (UIColor *)theme2 {
    return _theme2;
};

@synthesize theme3 = _theme3;

- (void)setTheme3:(UIColor *)theme3 {
    [theme3 retain];
    [_theme3 release];
    _theme3 = theme3;
};

- (UIColor *)theme3 {
    return _theme3;
};

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.theme1 = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        self.theme2 = [UIColor colorNamed:@"test"];
        self.theme3 = [UIColor colorWithRed: 0.97 green: 0.91 blue: 0.81 alpha: 1.00];
    }
    return self;
};

- (void)dealloc
{

    // Вот здесь, я попробовала вывести retainCount для каждого объекта
    // и оказалось, что они не освобождаются, так как retainCount для каждого > 1,
    // поэтому здесь я обниляю каждый объект и освобождаю.
    // Так же ранее цвет был указан только через UIColor.colorName, теперь
    // получилось сделать и чтобы не утекало через colorNamed.
    // Долго проверяла через Profile/Leaks, ничего обнаружить не удалось,
    // надеюсь, что решение правильное.

    self.theme1 = nil;
    self.theme2 = nil;
    self.theme3 = nil;

    [_theme1 release];
    [_theme2 release];
    [_theme3 release];

    [super dealloc];
};

@end
