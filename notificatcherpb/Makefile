export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:5.0

include theos/makefiles/common.mk

BUNDLE_NAME = NotificatcherPB
NotificatcherPB_FILES = NotificatcherPB.mm
NotificatcherPB_INSTALL_PATH = /Library/PreferenceBundles
NotificatcherPB_FRAMEWORKS = UIKit
NotificatcherPB_PRIVATE_FRAMEWORKS = Preferences CoreGraphics
NotificatcherPB_LDFLAGS += -Wl,-segalign,4000
NotificatcherPB_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotificatcherPB.plist$(ECHO_END)
