#import <Preferences/PSListController.h>
#import <Foundation/Foundation.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>

@interface ICRRootListController : HBListController
- (void)respring:(id)sender;

@end

#define screenWidth [[UIScreen mainScreen] bounds].size.width

@interface
 UIImage (Internal)
+ (id)imageNamed:(id)arg1 inBundle:(id)arg2;
@end

@interface
 ICRBannerCell : UITableViewCell { UIImageView* imgView; }
@end
