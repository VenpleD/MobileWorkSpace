export THEOS_DEVICE_IP=192.168.21.34
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREProject
iOSREProject_FILES = Tweak.xm
TARGET = iphone:latest:7.0

iOSREProject_FRAMEWORKS = UIKit WebKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
