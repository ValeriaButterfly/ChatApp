//
//  ThemesViewControllerDelegate.h
//  ChatApp
//
//  Created by Valeria Muldt on 12.10.2021.
//

#import <UIKit/UIKit.h>
@class ThemeListViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (ThemeListViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

NS_ASSUME_NONNULL_END
