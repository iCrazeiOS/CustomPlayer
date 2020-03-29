// Import Libraries
#import <libcolorpicker.h>
#import <Cephei/HBPreferences.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

// Define The Version Check (Used In ctor)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// Interfaces
@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface SBDashBoardAdjunctItemView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface MediaControlsMaterialView : UIView
@end

@interface SPTNowPlayingScrollCell : UIView
@end

@interface SPTNowPlayingCoverArtCell : UIView
@end

@interface _UIVisualEffectSubview : UIView
@property (nonatomic, assign, readwrite) CGFloat alpha;
-(id)_viewControllerForAncestor;
@end

// Preferences
NSMutableDictionary *colourPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.icraze.customplayercolours.plist"];
float kLyricifyAlpha = [[[NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.icraze.customplayerprefs.plist"] objectForKey:@"kLyricifyAlpha"] floatValue];
float kBorderWidth = [[[NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.icraze.customplayerprefs.plist"] objectForKey:@"kBorderWidth"] floatValue];
HBPreferences *prefs;

BOOL kEnabled;
BOOL kCCEnabled;
BOOL kSpotifyEnabled;
BOOL kHidePlayer;
BOOL kSolidEnabled;
BOOL kGradientEnabled;
BOOL kBorderEnabled;
BOOL kCCBorderEnabled;
BOOL kLyricifyEnabled;

// Spotify Code
%group Spotify
	%hook SPTNowPlayingScrollCell
	-(void)layoutSubviews {
		%orig;
		// Declare The Colour
		NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];
		self.superview.backgroundColor = LCPParseColorString(kSolidColour, @"#ff0000");
	}
	%end

	%hook SPTNowPlayingCoverArtCell
	-(void)layoutSubviews {
		%orig;
		// Declare The Colour
		NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];
		self.superview.backgroundColor = LCPParseColorString(kSolidColour, @"#ff0000");
	}
	%end
%end

// Lyricify Code
%group Lyricify
	%hook _UIVisualEffectSubview
	-(void)layoutSubviews {
		%orig;

		UIViewController* ancestorVC;

		ancestorVC = [self _viewControllerForAncestor];

		if (([ancestorVC isKindOfClass: %c(LyricifyLyricViewController)])) {
			if (kSolidEnabled) {
				NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];

				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;
				
				[self.superview.superview.layer insertSublayer:gradient atIndex:0];

				self.alpha = kLyricifyAlpha/100;
			} else if (kGradientEnabled) {
				NSString *kFirstColour = [colourPrefs objectForKey:@"kFirstColour"];
				NSString *kSecondColour = [colourPrefs objectForKey:@"kSecondColour"];

				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kFirstColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSecondColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;
					
				[self.superview.layer insertSublayer:gradient atIndex:0];

				self.alpha = kLyricifyAlpha/100;
			}
		}
	}
	%end
%end

// iOS 13 CC Code
%group iOS13CC
	// Hook The Media Player In The CC
	%hook MediaControlsMaterialView
	-(void)setFrame:(CGRect)arg1 {
		// Run The Original Code
		%orig;
		// Hide The Blur View
		self.hidden = YES;
		// Declare The Colour
		NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];

		// Set The Background Colour
		self.superview.backgroundColor = LCPParseColorString(kSolidColour, @"#ff0000");

		// Set The Corner Radius
		self.superview.layer.cornerRadius = 16.5;

		if (kCCBorderEnabled) {
			// Declare The Colour
			NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
			// Set The Border Colour
			self.superview.layer.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
			// Set The Border Width
			self.superview.layer.borderWidth = kBorderWidth;
		}
	}
	%end
%end

// iOS 13 Code
%group iOS13
	// Hook MTMaterialView
	%hook MTMaterialView
	-(void)setFrame:(CGRect)arg1 {
		// Run The Original Code
		%orig;
		// Make Sure It Only Modifies The Media Player, And Check That Flow Is Not Installed
		if (([self.superview class] == objc_getClass("PLPlatterView")) && (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Flow.dylib"])) {
			// Make Sure The Right Options Are Enabled
			if (kSolidEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colour
				NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];
				// Create The Gradient View
				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;

				if (kBorderEnabled) {
					// Declare The Colour
					NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
					// Set The Border Colour
					gradient.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
					// Set The Border Width
					gradient.borderWidth = kBorderWidth;
				}

				// Add The Gradient View
				[self.superview.layer insertSublayer:gradient atIndex:0];
			} else if (kGradientEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colours
				NSString *kFirstColour = [colourPrefs objectForKey:@"kFirstColour"];
				NSString *kSecondColour = [colourPrefs objectForKey:@"kSecondColour"];
				// Create The Gradient View
			   	CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kFirstColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSecondColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;

				if (kBorderEnabled) {
					// Declare The Colour
					NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
					// Set The Border Colour
					gradient.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
					// Set The Border Width
					gradient.borderWidth = kBorderWidth;
				}

				// Add The Gradient View
				[self.superview.layer insertSublayer:gradient atIndex:0];
			}
		}
	}
	%end

	// Hide Media Player On iOS 13
	%hook CSNowPlayingController
	-(id)controlsViewController {
		if (kHidePlayer) {
			return nil;
		} else {
			return %orig;
		}
	}
	%end
%end

// iOS 12 CC Code
%group iOS12CC
	// Hook The Media Player In The CC
	%hook MediaControlsMaterialView
	-(void)setFrame:(CGRect)arg1 {
		// Run The Original Code
		%orig;
		// Hide The Blur View
		self.hidden = YES;
		// Declare The Colour
		NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];

		// Set The Background Colour
		self.superview.backgroundColor = LCPParseColorString(kSolidColour, @"#ff0000");

		// Set The Corner Radius
		self.superview.layer.cornerRadius = 16.5;

		if (kCCBorderEnabled) {
			// Declare The Colour
			NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
			// Set The Border Colour
			self.superview.layer.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
			// Set The Border Width
			self.superview.layer.borderWidth = kBorderWidth;
		}
	}
	%end
%end

// iOS 12 Code
%group iOS12
	%hook MTMaterialView
	-(void)layoutSubviews {
		// Run The Original Code
		%orig;
		// Make Sure It Only Modifies The Media Player
		if ([self.superview class] == objc_getClass("SBDashBoardAdjunctItemPlatterView")) {
			// Make Sure The Right Options Are Enabled
			if (kSolidEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colour
				NSString *kSolidColour = [colourPrefs objectForKey:@"kSolidColour"];
				// Create The Gradient View
				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSolidColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = 16.5;

				if (kBorderEnabled) {
					// Declare The Colour
					NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
					// Set The Border Colour
					gradient.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
					// Set The Border Width
					gradient.borderWidth = kBorderWidth;
				}

				// Add The Gradient View
				[self.superview.superview.layer insertSublayer:gradient atIndex:0];
			} else if (kGradientEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colours
				NSString *kFirstColour = [colourPrefs objectForKey:@"kFirstColour"];
				NSString *kSecondColour = [colourPrefs objectForKey:@"kSecondColour"];

				// Create The Gradient View
			   	CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[LCPParseColorString(kFirstColour, @"#ff0000") CGColor], (id)[LCPParseColorString(kSecondColour, @"#ff0000") CGColor]];
				gradient.cornerRadius = 16.5;

				if (kBorderEnabled) {
					// Declare The Colour
					NSString *kBorderColour = [colourPrefs objectForKey:@"kBorderColour"];
					// Set The Border Colour
					gradient.borderColor = [LCPParseColorString(kBorderColour, @"#ff0000") CGColor];
					// Set The Border Width
					gradient.borderWidth = kBorderWidth;
				}

				// Add The Gradient View
				[self.superview.superview.layer insertSublayer:gradient atIndex:0];
			}
		}
	}
	%end

	// Hide Media Player On iOS 12
	%hook SBDashBoardAdjunctItemView
	-(id)initWithRecipe:(NSInteger)arg1 options:(NSUInteger)arg2 {
		if (kHidePlayer) {
			return nil;
		} else {
			return %orig;
		}
	}
	%end
%end

extern NSString *const HBPreferencesDidChangeNotification;

%ctor {
	// Preferences
	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.icraze.customplayerprefs"];

    [prefs registerBool:&kEnabled default:NO forKey:@"kEnabled"];
    [prefs registerBool:&kCCEnabled default:NO forKey:@"kCCEnabled"];
    [prefs registerBool:&kSpotifyEnabled default:NO forKey:@"kSpotifyEnabled"];
    [prefs registerBool:&kHidePlayer default:NO forKey:@"kHidePlayer"];
    [prefs registerBool:&kSolidEnabled default:NO forKey:@"kSolidEnabled"];
    [prefs registerBool:&kGradientEnabled default:NO forKey:@"kGradientEnabled"];
    [prefs registerBool:&kBorderEnabled default:NO forKey:@"kBorderEnabled"];
    [prefs registerBool:&kCCBorderEnabled default:NO forKey:@"kCCBorderEnabled"];
    [prefs registerBool:&kLyricifyEnabled default:NO forKey:@"kLyricifyEnabled"];

    if (!kEnabled) {
        return;
    }

    if (kSpotifyEnabled) {
    	%init(Spotify);
	}

	if (kLyricifyEnabled) {
		%init(Lyricify);
	}
	
	// iOS Version Check
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
		// Run iOS 13 Code
		%init(iOS13);
		if (kCCEnabled) {
			%init(iOS13CC);
		}
	} else {
		// Run iOS 12 Code
		%init(iOS12);
		if (kCCEnabled) {
			%init(iOS12CC);
		}
	}
}
