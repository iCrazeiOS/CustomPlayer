#include "ICRRootListController.h"
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <UIKit/UIKit.h>
#import <spawn.h>

@interface HBPackageNameHeaderCell : PSTableCell
@end

@interface HBTintedTableCell : PSTableCell
@end

@interface HBLinkTableCell : HBTintedTableCell
@end

@interface HBTwitterCell : HBLinkTableCell
@end

@interface HBImageTableCell : PSTableCell
@end

@implementation ICRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

-(void)email:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = @"iCrazeiOS@protonmail.com";

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email" message:@"Copied To Clipboard!" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
	                    }];
	[alert addAction:ok];
	[self presentViewController:alert animated:YES completion:nil];
}
@end

@implementation ICRBannerCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self) {
		UIImage* img = [UIImage imageNamed:@"banner" inBundle:[NSBundle bundleForClass:[self class]]];
		imgView = [[UIImageView alloc] init];
		imgView.frame = CGRectMake(0, -self.frame.origin.y, screenWidth, screenWidth * (img.size.height / img.size.width));
		imgView.image = img;
		imgView.backgroundColor = [UIColor redColor];
		[self addSubview:imgView];
	}
	return self;
}
- (void)didMoveToWindow {
	[super didMoveToWindow];
	imgView.frame = CGRectMake(0, -self.frame.origin.y, screenWidth, imgView.frame.size.height);
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return imgView.frame.size.height - 35;
}
@end

@implementation ICRSolidController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Solid" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Solid Colour"];
    return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end

@implementation ICRGradientController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Gradient" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Gradient"];
    return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end

@implementation ICRBorderController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Border" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Border"];
    return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end

@implementation ICRLyricifyController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Lyricify" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Lyricify Support"];
    return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end

@implementation ICRMiscController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Misc" target:self];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Miscellaneous"];
    return _specifiers;
}

-(void)loadView{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end
