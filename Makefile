TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PAIN_x_tkietn

PAIN_x_tkietn_FILES = Tweak.xm PAIN_x_tkietn_Menu.mm \
                      imgui/imgui.cpp imgui/imgui_draw.cpp imgui/imgui_tables.cpp imgui/imgui_widgets.cpp \
                      imgui/backends/imgui_impl_metal.mm

PAIN_x_tkietn_CFLAGS = -fobjc-arc -I./imgui -I./imgui/backends
PAIN_x_tkietn_FRAMEWORKS = UIKit Metal MetalKit QuartzCore Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

