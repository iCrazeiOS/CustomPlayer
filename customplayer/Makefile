ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomPlayer

CustomPlayer_FILES = ICRRootListController.m
CustomPlayer_INSTALL_PATH = /Library/PreferenceBundles
CustomPlayer_FRAMEWORKS = UIKit
CustomPlayer_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
CustomPlayer_LIBRARIES = colorpicker
CustomPlayer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomPlayer.plist$(ECHO_END)
