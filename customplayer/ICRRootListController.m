#include "ICRRootListController.h"
#import <spawn.h>

@implementation ICRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring:(id)sender {
	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

-(void)twitter:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.twitter.com/iCrazeiOS"] options:@{} completionHandler:nil];
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

-(void)paypal:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/iCrazeiOS/2"] options:@{} completionHandler:nil];
}

-(void)patreon:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.patreon.com/join/iCrazeiOS?"] options:@{} completionHandler:nil];
}

@end
