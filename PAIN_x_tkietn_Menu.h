// ============================================================================
// PAIN x tkietn - iOS Dear ImGui Menu Header
// Target: iOS arm64 / arm64e (Metal + Objective-C++)
// ============================================================================

#ifndef PAIN_X_TKIETN_MENU_H
#define PAIN_X_TKIETN_MENU_H

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

namespace PainXTkietn {

    struct Settings {
        bool isLoggedIn = false;
        bool isMenuOpen = false;
        bool isLightTheme = false;
        int activeTab = 0; // 0 = Combat, 1 = Visuals, 2 = Keybinds, 3 = About

        // Authentication
        char licenseKey[64] = "PAIN-PRO-2026-X92K-892A";
        bool rememberMe = true;
        bool isPasswordMasked = false;

        // Combat (7 items left, 6 items right)
        bool enableExternal = true;
        bool alwaysOn = true;
        bool ignoreKnocked = true;
        bool noRecoil = true;
        bool silentAim = true;
        bool autoFire = true;
        bool noReload = true;

        int boneIndex = 0; // 0: Neck, 1: Head, 2: Chest, 3: Pelvis
        float fovValue = 357.0f;
        bool legitMode = true;
        bool aimLock = true;
        bool fastFire = true;
        bool fastReload = true;

        // Visuals
        bool espLine = true;
        bool espBox = true;
        bool espHealth = true;
        bool espSkeleton = true;
        bool espDistance = true;
        bool enemyPlayer = true;

        // HWID & License Display
        std::string fullKey = "PAIN-PRO-2026-X92K-892A";
        std::string deviceHwid = "IOS-94F2-88C1-004B";
        std::string buildVer = "Pain x tkietn v4.2.0";
    };

    extern Settings g_State;

    // Khởi tạo Dear ImGui cho iOS Metal
    void SetupImGui(MTKView* view);

    // Render frame
    void RenderUI(MTKView* view);

    // Xử lý sự kiện chạm cảm ứng iOS (Touches)
    bool HandleTouch(UIView* view, NSSet<UITouch*>* touches, UIEvent* event, int phase);

    // Hiển thị các thành phần GUI
    void RenderLoginWindow(bool* isLoggedIn);
    void RenderFloatingPill(bool* isMenuOpen);
    void RenderMainMenu(bool* isMenuOpen, bool* isLightTheme);
}

#endif // PAIN_X_TKIETN_MENU_H

