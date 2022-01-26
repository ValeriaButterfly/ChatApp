//
//  UIViewController+ThemesViewController.m
//  ChatApp
//
//  Created by Valeria Muldt on 11.10.2021.
//

#import "ThemeListViewController.h"

@implementation ThemeListViewController

@synthesize delegate = _delegate;

- (void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    _delegate = delegate;
};

- (id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}

@synthesize model = _model;

- (void)setModel:(Themes *)model {
    _model = model;
};

- (Themes *)model {
    return _model;
};

- (void)viewDidLoad {
    self.model = [[Themes alloc]init];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Close"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action: @selector(closeView:)];
    self.navigationItem.rightBarButtonItem = closeButton;

    [closeButton release];
};

- (void)dealloc
{
    [self.model release];

    [super dealloc];
};

- (void)firstThemeAction:(id)sender {
    [self.navigationController.navigationBar setBarTintColor:self.model.theme1];
    [self.delegate themesViewController:self didSelectTheme:self.model.theme1];
};

- (void)secondThemeAction:(id)sender {
    [self.navigationController.navigationBar setBarTintColor:self.model.theme2];
    [self.delegate themesViewController:self didSelectTheme:self.model.theme2];
};

- (void)thirdThemeAction:(id)sender {
    [self.navigationController.navigationBar setBarTintColor:self.model.theme3];
    [self.delegate themesViewController:self didSelectTheme:self.model.theme3];
};

- (void)closeView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
};

@end
