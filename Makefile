ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomPlayer

CustomPlayer_FILES = Tweak.xm
CustomPlayer_LIBRARIES = sparkcolourpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += customplayer
include $(THEOS_MAKE_PATH)/aggregate.mk
