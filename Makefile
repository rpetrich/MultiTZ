TWEAK_NAME = MultiTZ
MultiTZ_FILES = Tweak.x

IPHONE_ARCHS = armv7 arm64
ADDITIONAL_CFLAGS = -std=c99
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

TWEAK_TARGET_PROCESS = SpringBoard

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk
