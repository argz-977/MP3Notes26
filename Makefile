ARCHS = arm64
TARGET = iphone:clang:16.3:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotesMP3Tweak

NotesMP3Tweak_FILES = Tweak.xm
NotesMP3Tweak_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Notes"
