SDKVERSION = 4.1
HDPhotographer_PRIVATE_FRAMEWORKS = PhotoLibrary

include theos/makefiles/common.mk

TWEAK_NAME = HDPhotographer
HDPhotographer_FILES = HDPhotographer.mm PLCameraHDButton.mm

include $(THEOS_MAKE_PATH)/tweak.mk
