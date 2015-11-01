export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:5.0

include theos/makefiles/common.mk

TWEAK_NAME = Notificatcher
Notificatcher_FILES = Tweak.xm
Notificatcher_FRAMEWORKS = CoreFoundation
Notificatcher_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)cp -r PreferenceBundles $(THEOS_STAGING_DIR)/Library$(ECHO_END)
	$(ECHO_NOTHING)cp -r PreferenceLoader $(THEOS_STAGING_DIR)/Library$(ECHO_END)
	
after-install::
	install.exec "killall -9 SpringBoard"
