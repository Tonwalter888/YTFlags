TARGET := iphone:clang:latest:14.0
FINALPACKAGE = 1
DEBUG = 0
INSTALL_TARGET_PROCESSES = YouTube
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YTFlags

$(TWEAK_NAME)_FILES = Flags.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk