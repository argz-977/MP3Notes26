ARCHS = arm64
TARGET = iphone:clang:16.3:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MP3Notes26

MP3Notes26_FILES = Tweak.xm
MP3Notes26_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Notes"
