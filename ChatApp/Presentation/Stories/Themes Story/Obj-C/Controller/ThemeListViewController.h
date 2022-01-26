//
//  ThemeListViewController.h
//  ChatApp
//
//  Created by Valeria Muldt on 11.10.2021.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemeListViewController : UIViewController

@property (retain) id<ThemesViewControllerDelegate> delegate;
@property (nonatomic, retain) Themes *model;

- (IBAction)firstThemeAction:(id)sender;
- (IBAction)secondThemeAction:(id)sender;
- (IBAction)thirdThemeAction:(id)sender;

- (IBAction)closeView:(id)sender;

@end

NS_ASSUME_NONNULL_END
