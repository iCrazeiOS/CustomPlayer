// Import Libraries
#import <SparkColourPickerUtils.h>

// Define The Version Check (Used In ctor)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// Interfaces
@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface SBDashBoardAdjunctItemView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

// Preferences
static NSMutableDictionary *prefs;
static bool kEnabled;
static bool kSolidEnabled;
static bool kGradientEnabled;
static bool kHidePlayer;

NSMutableDictionary* colourPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.icraze.customplayercolours.plist"];

// loadPrefs Method
static void loadPrefs() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.icraze.customplayerprefs.plist"];
	kEnabled = [prefs valueForKey:@"kEnabled"] ? [[prefs valueForKey:@"kEnabled"] boolValue] : YES;
	kSolidEnabled = [prefs valueForKey:@"kSolidEnabled"] ? [[prefs valueForKey:@"kSolidEnabled"] boolValue] : YES;
	kGradientEnabled = [prefs valueForKey:@"kGradientEnabled"] ? [[prefs valueForKey:@"kGradientEnabled"] boolValue] : YES;
	kHidePlayer = [prefs valueForKey:@"kHidePlayer"] ? [[prefs valueForKey:@"kHidePlayer"] boolValue] : YES;
}

// iOS 13 Code
%group iOS13
	// Hook MTMaterialView
	%hook MTMaterialView
	-(void)setFrame:(CGRect)arg1 {
		// Run The Original Code
		%orig;
		// Make Sure It Only Modifies The Media Player
		if ([self.superview class] == objc_getClass("PLPlatterView")) {
			// Make Sure The Right Options Are Enabled
			if (kEnabled && kSolidEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colour
				NSString* kSolidColour = [colourPrefs objectForKey: @"kSolidColour"];
				// Create The Gradient View
				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[[SparkColourPickerUtils colourWithString: kSolidColour withFallback: @"#ff0000"] CGColor], (id)[[SparkColourPickerUtils colourWithString: kSolidColour withFallback: @"#ff0000"] CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;

				// Add The Gradient View
				[self.superview.layer insertSublayer:gradient atIndex:0];
			} else if (kEnabled && kGradientEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colours
				NSString* kFirstColour = [colourPrefs objectForKey: @"kFirstColour"];
				NSString* kSecondColour = [colourPrefs objectForKey: @"kSecondColour"];
				// Create The Gradient View
			   	CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[[SparkColourPickerUtils colourWithString: kFirstColour withFallback: @"#ff0000"] CGColor], (id)[[SparkColourPickerUtils colourWithString: kSecondColour withFallback: @"#ff0000"] CGColor]];
				gradient.cornerRadius = self.layer.cornerRadius;

				// Add The Gradient View
				[self.superview.layer insertSublayer:gradient atIndex:0];
			}
		}
	}
	%end

	// Hide Media Player On iOS 13
	%hook CSNowPlayingController
	-(id)controlsViewController {
		if (kEnabled && kHidePlayer) {
			return nil;
		} else {
			return %orig;
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
			if (kEnabled && kSolidEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colour
				NSString* kSolidColour = [colourPrefs objectForKey: @"kSolidColour"];
				// Create The Gradient View
				CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[[SparkColourPickerUtils colourWithString: kSolidColour withFallback: @"#ff0000"] CGColor], (id)[[SparkColourPickerUtils colourWithString: kSolidColour withFallback: @"#ff0000"] CGColor]];
				gradient.cornerRadius = 16.5;

				// Add The Gradient View
				[self.superview.superview.layer insertSublayer:gradient atIndex:0];
			} else if (kEnabled && kGradientEnabled && !kHidePlayer) {
				// Hide The Blur
				self.hidden = YES;
				// Declare The Colours
				NSString* kFirstColour = [colourPrefs objectForKey: @"kFirstColour"];
				NSString* kSecondColour = [colourPrefs objectForKey: @"kSecondColour"];

				// Create The Gradient View
			   	CAGradientLayer *gradient = [CAGradientLayer layer];

				gradient.frame = self.superview.bounds;
				gradient.colors = @[(id)[[SparkColourPickerUtils colourWithString: kFirstColour withFallback: @"#ff0000"] CGColor], (id)[[SparkColourPickerUtils colourWithString: kSecondColour withFallback: @"#ff0000"] CGColor]];
				gradient.cornerRadius = 16.5;

				// Add The Gradient View
				[self.superview.superview.layer insertSublayer:gradient atIndex:0];
			}
		}
	}
	%end

	// Hide Media Player On iOS 12
	%hook SBDashBoardAdjunctItemView
	-(id)initWithRecipe:(NSInteger)arg1 options:(NSUInteger)arg2 {
		if (kEnabled && kHidePlayer) {
			return nil;
		} else {
			return %orig;
		}
	}
	%end
%end

%ctor {
	// Load Preferences
	loadPrefs();
	// iOS Version Check
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
		// Run iOS 13 Code
		%init(iOS13);
	} else {
		// Run iOS 12 Code
		%init(iOS12);
	}
}
