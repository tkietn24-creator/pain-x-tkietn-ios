// ============================================================================
// PAIN x tkietn - iOS Hook & Touch Forwarder (Tweak.xm)
// Target: Hook CAMetalLayer / MTKView in iOS Games
// ============================================================================

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "PAIN_x_tkietn_Menu.h"

// ----------------------------------------------------------------------------
// HOOK MTKVIEW RENDER LOOP
// ----------------------------------------------------------------------------
%hook MTKView

- (void)draw {
    %orig;

    // Khởi tạo và vẽ giao diện ImGui lên lớp trên cùng của game
    PainXTkietn::SetupImGui(self);
    PainXTkietn::RenderUI(self);
}

%end

// ----------------------------------------------------------------------------
// HOOK UIWINDOW / UIVIEW TOUCH EVENTS ĐỂ ĐIỀU KHIỂN CẢM ỨNG
// ----------------------------------------------------------------------------
%hook UIWindow

- (void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        NSSet *touches = [event allTouches];
        UITouch *touch = [touches anyObject];

        int phase = 0;
        if (touch.phase == UITouchPhaseBegan) phase = 0;
        else if (touch.phase == UITouchPhaseMoved) phase = 1;
        else if (touch.phase == UITouchPhaseEnded) phase = 2;
        else if (touch.phase == UITouchPhaseCancelled) phase = 3;

        // Nếu người dùng đang tương tác với menu hoặc viên thuốc, chặn truyền touch vào game
        bool captured = PainXTkietn::HandleTouch(self, touches, event, phase);
        if (captured && (PainXTkietn::g_State.isMenuOpen || !PainXTkietn::g_State.isLoggedIn)) {
            return;
        }
    }

    %orig;
}

%end

