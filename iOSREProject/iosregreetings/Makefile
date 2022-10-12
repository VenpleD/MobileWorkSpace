export THEOS_DEVICE_IP=192.168.21.34
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREGreetings
iOSREGreetings_FILES = Tweak.xm
TARGET=iphone:latest:7.0

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
