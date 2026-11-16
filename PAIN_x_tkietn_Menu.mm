// ============================================================================
// PAIN x tkietn - iOS Dear ImGui Menu Implementation (Metal Backend)
// ============================================================================

#include "PAIN_x_tkietn_Menu.h"
#include "imgui.h"
#include "imgui_internal.h"
#include "backends/imgui_impl_metal.h"

namespace PainXTkietn {

    Settings g_State;
    static bool g_Initialized = false;

    // ------------------------------------------------------------------------
    // SETUP IMGUI FOR IOS METAL
    // ------------------------------------------------------------------------
    void SetupImGui(MTKView* view) {
        if (g_Initialized) return;

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();
        ImGuiIO& io = ImGui::GetIO();

        // Kích hoạt font và tỉ lệ màn hình Retina iOS
        CGFloat scale = [UIScreen mainScreen].nativeScale;
        io.DisplayFramebufferScale = ImVec2(scale, scale);

        // Khởi tạo Metal backend
        ImGui_ImplMetal_Init(view.device);

        // Style phong cách tối giản Dark Matte
        ImGuiStyle& style = ImGui::GetStyle();
        style.WindowRounding = 20.0f;
        style.ChildRounding = 10.0f;
        style.FrameRounding = 8.0f;
        style.WindowBorderSize = 1.0f;
        style.ChildBorderSize = 1.0f;
        style.FrameBorderSize = 1.0f;

        g_Initialized = true;
    }

    // ------------------------------------------------------------------------
    // TOUCH EVENT DISPATCHER FOR IOS
    // ------------------------------------------------------------------------
    bool HandleTouch(UIView* view, NSSet<UITouch*>* touches, UIEvent* event, int phase) {
        ImGuiIO& io = ImGui::GetIO();
        UITouch* touch = [touches anyObject];
        CGPoint loc = [touch locationInView:view];

        CGFloat scale = [UIScreen mainScreen].nativeScale;
        io.MousePos = ImVec2(loc.x * (io.DisplaySize.x / view.bounds.size.width),
                             loc.y * (io.DisplaySize.y / view.bounds.size.height));

        if (phase == 0) { // touchesBegan
            io.MouseDown[0] = true;
        } else if (phase == 1) { // touchesMoved
            io.MouseDown[0] = true;
        } else if (phase == 2 || phase == 3) { // touchesEnded / Cancelled
            io.MouseDown[0] = false;
        }

        return io.WantCaptureMouse;
    }

    // ------------------------------------------------------------------------
    // 1. MÀN HÌNH ĐĂNG NHẬP LOGIN (640x380 px)
    // ------------------------------------------------------------------------
    void RenderLoginWindow(bool* isLoggedIn) {
        if (*isLoggedIn) return;

        ImGuiViewport* vp = ImGui::GetMainViewport();
        ImVec2 centerPos(vp->WorkPos.x + (vp->WorkSize.x - 640.0f) * 0.5f,
                         vp->WorkPos.y + (vp->WorkSize.y - 380.0f) * 0.5f);

        ImGui::SetNextWindowPos(centerPos, ImGuiCond_Appearing);
        ImGui::SetNextWindowSize(ImVec2(640.0f, 380.0f), ImGuiCond_Always);

        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 24.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(20.0f, 18.0f));
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1.0f);

        ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.047f, 0.055f, 0.063f, 0.98f)); // #0C0E10
        ImGui::PushStyleColor(ImGuiCol_Border,   ImVec4(0.137f, 0.153f, 0.169f, 1.0f)); // #23272B

        ImGui::Begin("##LoginScreen", nullptr, 
            ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar);

        // Header: PAIN x tkietn + v1.0
        {
            ImGui::TextColored(ImVec4(1.0f, 1.0f, 1.0f, 1.0f), "PAIN x tkietn");

            ImGui::SameLine(0, 10.0f);
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() - 2.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 10.0f);
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.086f, 0.094f, 0.105f, 1.0f));
            ImGui::PushStyleColor(ImGuiCol_Text,   ImVec4(0.49f, 0.52f, 0.55f, 1.0f));
            ImGui::Button("v1.0", ImVec2(36.0f, 20.0f));
            ImGui::PopStyleColor(2);
            ImGui::PopStyleVar();

            ImGui::SameLine(ImGui::GetWindowWidth() - 40.0f);
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 2.0f);
            ImGui::TextColored(ImVec4(0.49f, 0.52f, 0.55f, 1.0f), "x");
        }

        ImGui::Spacing();
        ImGui::Spacing();

        // 2 Cột: Bên trái Anime Placeholder | Bên phải Form nhập Key
        ImGui::Columns(2, "##LoginColumns", false);
        ImGui::SetColumnWidth(0, 200.0f);

        // Vẽ placeholder hoặc ảnh anime
        ImDrawList* draw = ImGui::GetWindowDrawList();
        ImVec2 cur = ImGui::GetCursorScreenPos();
        draw->AddRectFilled(cur, ImVec2(cur.x + 185.0f, cur.y + 285.0f), IM_COL32(18, 20, 23, 255), 16.0f);
        draw->AddText(ImVec2(cur.x + 45.0f, cur.y + 135.0f), IM_COL32(100, 105, 115, 255), "[Anime Character]");
        ImGui::Dummy(ImVec2(185.0f, 285.0f));

        ImGui::NextColumn();

        // Cột Form (Khớp chuẩn Ảnh 2)
        {
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 12.0f);
            ImGui::TextColored(ImVec4(1.0f, 1.0f, 1.0f, 1.0f), "Account & License Login");
            ImGui::TextColored(ImVec4(0.49f, 0.52f, 0.55f, 1.0f), "Enter your key or sign in to continue");
            
            ImGui::Spacing();
            ImGui::Spacing();

            // Khung nhập License Key
            ImGui::PushStyleVar(ImGuiStyleVar_ChildRounding, 12.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_ChildBorderSize, 1.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(12.0f, 0.0f));
            ImGui::PushStyleColor(ImGuiCol_ChildBg, IM_COL32(14, 16, 18, 255));
            ImGui::PushStyleColor(ImGuiCol_Border,  IM_COL32(35, 39, 43, 255));

            ImGui::BeginChild("##KeyContainer", ImVec2(380.0f, 42.0f), true, ImGuiWindowFlags_NoScrollbar);
            
            ImGui::SetCursorPosY((42.0f - ImGui::GetTextLineHeight()) * 0.5f);
            ImGui::TextColored(ImVec4(0.96f, 0.70f, 0.04f, 1.0f), "key"); // Chìa khóa vàng

            ImGui::SameLine(0, 10.0f);
            ImGui::SetCursorPosY(8.0f);
            ImGui::PushItemWidth(300.0f);
            ImGui::PushStyleColor(ImGuiCol_FrameBg, IM_COL32(0, 0, 0, 0));
            ImGuiInputTextFlags flags = g_State.isPasswordMasked ? ImGuiInputTextFlags_Password : ImGuiInputTextFlags_None;
            ImGui::InputTextWithHint("##KeyInput", "Enter license key...", g_State.licenseKey, sizeof(g_State.licenseKey), flags);
            ImGui::PopStyleColor();
            ImGui::PopItemWidth();

            ImGui::SameLine(380.0f - 30.0f);
            ImGui::SetCursorPosY((42.0f - ImGui::GetTextLineHeight()) * 0.5f);
            if (ImGui::Selectable("eye", false, 0, ImVec2(20.0f, 20.0f))) {
                g_State.isPasswordMasked = !g_State.isPasswordMasked;
            }

            ImGui::EndChild();
            ImGui::PopStyleColor(2);
            ImGui::PopStyleVar(3);

            ImGui::Spacing();

            // Remember me & Purchase / Reset HWID
            {
                ImGui::Checkbox("Remember me", &g_State.rememberMe);
                if (g_State.rememberMe) {
                    ImGui::SameLine(0, 6.0f);
                    ImGui::TextColored(ImVec4(0.20f, 0.85f, 0.45f, 1.0f), "• Saved");
                }

                ImGui::SameLine(240.0f);
                ImGui::TextColored(ImVec4(0.49f, 0.52f, 0.55f, 1.0f), "Purchase / Reset HWID");
            }

            ImGui::Spacing();
            ImGui::Spacing();

            // Nút Authenticate & Launch
            ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 12.0f);
            ImGui::PushStyleColor(ImGuiCol_Button,        ImVec4(0.14f, 0.15f, 0.16f, 1.0f));
            ImGui::PushStyleColor(ImGuiCol_Border,        ImVec4(0.35f, 0.38f, 0.42f, 0.8f));
            ImGui::PushStyleVar(ImGuiStyleVar_FrameBorderSize, 1.0f);

            if (ImGui::Button("Authenticate & Launch", ImVec2(380.0f, 42.0f))) {
                if (strlen(g_State.licenseKey) > 0) {
                    *isLoggedIn = true; // MỞ KHÓA MENU
                }
            }

            ImGui::PopStyleVar(2);
            ImGui::PopStyleColor(2);
        }

        ImGui::Columns(1);
        ImGui::End();

        ImGui::PopStyleColor(2);
        ImGui::PopStyleVar(3);
    }

    // ------------------------------------------------------------------------
    // 2. VIÊN THUỐC BẬT/TẮT KÉO THẢ (PAIN x tkietn)
    // ------------------------------------------------------------------------
    void RenderFloatingPill(bool* isMenuOpen) {
        ImGui::SetNextWindowPos(ImVec2(32.0f, 24.0f), ImGuiCond_FirstUseEver);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 16.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(10.0f, 6.0f));
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1.0f);
        ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.067f, 0.075f, 0.082f, 0.95f));
        ImGui::PushStyleColor(ImGuiCol_Border,   ImVec4(0.169f, 0.184f, 0.200f, 1.0f));

        ImGui::Begin("##DraggablePill", nullptr,
            ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize |
            ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoSavedSettings);

        // Badge [P] đỏ
        ImDrawList* draw = ImGui::GetWindowDrawList();
        ImVec2 cur = ImGui::GetCursorScreenPos();
        draw->AddRectFilled(cur, ImVec2(cur.x + 18.0f, cur.y + 18.0f), IM_COL32(45, 17, 19, 255), 4.0f);
        draw->AddRect(cur, ImVec2(cur.x + 18.0f, cur.y + 18.0f), IM_COL32(92, 28, 32, 255), 4.0f);
        draw->AddText(ImVec2(cur.x + 5.0f, cur.y + 2.0f), IM_COL32(255, 51, 58, 255), "P");
        ImGui::Dummy(ImVec2(18.0f, 18.0f));

        ImGui::SameLine(0, 8.0f);
        ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 1.0f);
        ImGui::TextColored(ImVec4(1.0f, 1.0f, 1.0f, 1.0f), "PAIN x tkietn");

        // Đèn LED trạng thái
        ImGui::SameLine(0, 8.0f);
        ImVec2 ledPos = ImGui::GetCursorScreenPos();
        ImU32 ledColor = *isMenuOpen ? IM_COL32(52, 211, 153, 255) : IM_COL32(248, 113, 113, 255);
        draw->AddCircleFilled(ImVec2(ledPos.x + 4.0f, ledPos.y + 7.0f), 2.5f, ledColor);
        ImGui::Dummy(ImVec2(8.0f, 8.0f));

        // Phân biệt drag và tap
        if (ImGui::IsWindowHovered() && ImGui::IsMouseReleased(0) && !ImGui::IsMouseDragging(0, 4.0f)) {
            *isMenuOpen = !(*isMenuOpen);
        }

        ImGui::End();
        ImGui::PopStyleColor(2);
        ImGui::PopStyleVar(3);
    }

    // ------------------------------------------------------------------------
    // CÁC HÀM TIỆN ÍCH CHO CARD VÀ WIDGET
    // ------------------------------------------------------------------------
    void BeginCard(const char* id, float height = 38.0f) {
        ImGui::PushStyleVar(ImGuiStyleVar_ChildRounding, 10.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(16.0f, 0.0f));
        ImGui::PushStyleVar(ImGuiStyleVar_ChildBorderSize, 1.0f);
        ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0.067f, 0.075f, 0.078f, 1.0f)); // #111314
        ImGui::PushStyleColor(ImGuiCol_Border,  ImVec4(0.121f, 0.133f, 0.141f, 1.0f)); // #1F2224
        ImGui::PushStyleColor(ImGuiCol_Text,    ImVec4(0.925f, 0.925f, 0.925f, 1.0f)); // #ECECEC

        ImGui::BeginChild(id, ImVec2(0, height), true, 
            ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse);
    }

    void EndCard() {
        ImGui::EndChild();
        ImGui::PopStyleColor(3);
        ImGui::PopStyleVar(3);
        ImGui::ItemSize(ImVec2(0, 6.0f));
    }

    bool RenderToggleCard(const char* label, bool* v) {
        BeginCard(label, 38.0f);
        ImDrawList* draw = ImGui::GetWindowDrawList();
        ImVec2 pos = ImGui::GetWindowPos();
        ImVec2 size = ImGui::GetWindowSize();

        float textY = pos.y + (size.y - ImGui::GetTextLineHeight()) * 0.5f;
        draw->AddText(ImVec2(pos.x + 16.0f, textY), IM_COL32(236, 236, 236, 255), label);

        float swW = 36.0f, swH = 19.0f;
        ImVec2 swMin(pos.x + size.x - swW - 16.0f, pos.y + (size.y - swH) * 0.5f);
        ImVec2 swMax(swMin.x + swW, swMin.y + swH);

        ImGui::SetCursorScreenPos(swMin);
        bool clicked = ImGui::InvisibleButton(label, ImVec2(swW, swH));
        if (clicked) *v = !(*v);

        ImU32 trackCol  = *v ? IM_COL32(10, 11, 12, 255) : IM_COL32(8, 9, 10, 255);
        ImU32 borderCol = *v ? IM_COL32(37, 40, 43, 255) : IM_COL32(28, 30, 32, 255);
        draw->AddRectFilled(swMin, swMax, trackCol, swH * 0.5f);
        draw->AddRect(swMin, swMax, borderCol, swH * 0.5f, 0, 1.0f);

        float radius = 7.0f;
        float thumbX = *v ? (swMax.x - radius - 2.5f) : (swMin.x + radius + 2.5f);
        float thumbY = swMin.y + swH * 0.5f;

        if (*v) {
            draw->AddCircleFilled(ImVec2(thumbX, thumbY), radius + 2.5f, IM_COL32(255, 255, 255, 45));
        }
        draw->AddCircleFilled(ImVec2(thumbX, thumbY), radius, *v ? IM_COL32(255, 255, 255, 255) : IM_COL32(102, 106, 112, 255));

        EndCard();
        return clicked;
    }

    bool RenderBoneComboCard(const char* label, int* current_item, const char* const items[], int items_count) {
        BeginCard(label, 38.0f);
        ImDrawList* draw = ImGui::GetWindowDrawList();
        ImVec2 pos = ImGui::GetWindowPos();
        ImVec2 size = ImGui::GetWindowSize();

        float textY = pos.y + (size.y - ImGui::GetTextLineHeight()) * 0.5f;
        draw->AddText(ImVec2(pos.x + 16.0f, textY), IM_COL32(236, 236, 236, 255), label);

        float comboW = 72.0f;
        ImGui::SetCursorScreenPos(ImVec2(pos.x + size.x - comboW - 16.0f, pos.y + (size.y - 24.0f) * 0.5f));
        ImGui::PushItemWidth(comboW);
        ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 6.0f);
        ImGui::PushStyleColor(ImGuiCol_FrameBg, IM_COL32(14, 16, 17, 255));
        ImGui::PushStyleColor(ImGuiCol_Border,  IM_COL32(38, 42, 45, 255));

        bool changed = ImGui::Combo("##BoneCombo", current_item, items, items_count);

        ImGui::PopStyleColor(2);
        ImGui::PopStyleVar();
        ImGui::PopItemWidth();

        EndCard();
        return changed;
    }

    bool RenderFovSliderCard(const char* label, float* v, float v_min, float v_max) {
        BeginCard(label, 38.0f);
        ImDrawList* draw = ImGui::GetWindowDrawList();
        ImVec2 pos = ImGui::GetWindowPos();
        ImVec2 size = ImGui::GetWindowSize();

        float textY = pos.y + (size.y - ImGui::GetTextLineHeight()) * 0.5f;
        draw->AddText(ImVec2(pos.x + 16.0f, textY), IM_COL32(236, 236, 236, 255), label);

        float sliderWidth = 125.0f;
        float numberWidth = 32.0f;
        ImVec2 sliderMin(pos.x + size.x - sliderWidth - numberWidth - 16.0f, pos.y + (size.y - 18.0f) * 0.5f);
        ImVec2 sliderMax(sliderMin.x + sliderWidth, sliderMin.y + 18.0f);

        ImGui::SetCursorScreenPos(sliderMin);
        ImGui::InvisibleButton("##FovSliderBtn", ImVec2(sliderWidth, 18.0f));

        if (ImGui::IsItemActive()) {
            float mouseX = ImGui::GetIO().MousePos.x;
            float ratio = ImClamp((mouseX - sliderMin.x) / sliderWidth, 0.0f, 1.0f);
            *v = v_min + ratio * (v_max - v_min);
        }

        float midY = sliderMin.y + 9.0f;
        float progress = (*v - v_min) / (v_max - v_min);
        float grabX = sliderMin.x + progress * sliderWidth;

        draw->AddLine(ImVec2(sliderMin.x, midY), ImVec2(sliderMax.x, midY), IM_COL32(255, 255, 255, 255), 3.0f);
        draw->AddCircleFilled(ImVec2(grabX, midY), 8.5f, IM_COL32(255, 255, 255, 80));
        draw->AddCircleFilled(ImVec2(grabX, midY), 6.5f, IM_COL32(255, 255, 255, 255));

        char numBuf[16];
        snprintf(numBuf, sizeof(numBuf), "%d", (int)*v);
        draw->AddText(ImVec2(pos.x + size.x - numberWidth - 12.0f, textY), IM_COL32(255, 255, 255, 255), numBuf);

        EndCard();
        return ImGui::IsItemActive();
    }

    // ------------------------------------------------------------------------
    // 3. CỬA SỔ MENU CHÍNH (PAIN x tkietn 710x440) - ĐÃ BỎ HẲN EXPLOITS
    // ------------------------------------------------------------------------
    void RenderMainMenu(bool* isMenuOpen, bool* isLightTheme) {
        if (!(*isMenuOpen)) return;

        ImGui::SetNextWindowPos(ImVec2(200.0f, 80.0f), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(710.0f, 440.0f), ImGuiCond_FirstUseEver);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 22.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(16.0f, 14.0f));
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1.0f);

        ImVec4 bgCol    = *isLightTheme ? ImVec4(1.0f, 1.0f, 1.0f, 1.0f) : ImVec4(0.055f, 0.059f, 0.067f, 1.0f);
        ImVec4 borderCol= *isLightTheme ? ImVec4(0.0f, 0.0f, 0.0f, 1.0f) : ImVec4(0.137f, 0.149f, 0.161f, 1.0f);
        ImVec4 titleCol = *isLightTheme ? ImVec4(0.0f, 0.0f, 0.0f, 1.0f) : ImVec4(1.00f, 1.00f, 1.00f, 1.0f);

        ImGui::PushStyleColor(ImGuiCol_WindowBg, bgCol);
        ImGui::PushStyleColor(ImGuiCol_Border,   borderCol);

        ImGui::Begin("##PainXTkietnMain", isMenuOpen, 
            ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar);

        // --- HEADER BAR TINH GỌN (ĐÃ XÓA EXPLOITS) ---
        {
            // Badge P đỏ
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.176f, 0.067f, 0.075f, 1.0f));
            ImGui::PushStyleColor(ImGuiCol_Text,   ImVec4(1.0f, 0.20f, 0.23f, 1.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 6.0f);
            ImGui::Button("P", ImVec2(24.0f, 24.0f));
            ImGui::PopStyleVar();
            ImGui::PopStyleColor(2);

            ImGui::SameLine(0, 10.0f);
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 4.0f);
            ImGui::TextColored(titleCol, "PAIN x tkietn");

            // Controls bên phải
            float rightX = ImGui::GetWindowWidth() - 70.0f;
            ImGui::SameLine(rightX);
            if (ImGui::Button(*isLightTheme ? "Dark" : "Light", ImVec2(44.0f, 22.0f))) {
                *isLightTheme = !(*isLightTheme);
            }
            ImGui::SameLine(0, 8.0f);
            if (ImGui::Selectable("x", false, 0, ImVec2(16.0f, 18.0f))) {
                *isMenuOpen = false;
            }
        }

        ImGui::Spacing();

        // --- SUB-NAVIGATION BAR (Combat, Visuals, Keybinds, About) ---
        {
            ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0.071f, 0.078f, 0.082f, 1.0f));
            ImGui::PushStyleColor(ImGuiCol_Border,  ImVec4(0.125f, 0.137f, 0.149f, 1.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_ChildRounding, 18.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(4.0f, 3.0f));
            ImGui::BeginChild("##SubNavBar", ImVec2(0, 36.0f), true, ImGuiWindowFlags_NoScrollbar);

            const char* subTitles[] = { "Combat", "Visuals", "Keybinds", "About" };
            const char* subIcons[]  = { "⊙", "👁", "🎮", "ℹ" };
            float tabWidth = (ImGui::GetContentRegionAvail().x - 12.0f) / 4.0f;

            for (int i = 0; i < 4; i++) {
                bool active = (g_State.activeTab == i);
                ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 15.0f);

                if (active) {
                    ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.133f, 0.145f, 0.157f, 1.0f));
                    ImGui::PushStyleColor(ImGuiCol_Border, ImVec4(0.204f, 0.224f, 0.243f, 1.0f));
                    ImGui::PushStyleVar(ImGuiStyleVar_FrameBorderSize, 1.0f);
                    ImGui::PushStyleColor(ImGuiCol_Text,   ImVec4(1.0f, 1.0f, 1.0f, 1.0f));
                } else {
                    ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0, 0, 0, 0));
                    ImGui::PushStyleColor(ImGuiCol_Border, ImVec4(0, 0, 0, 0));
                    ImGui::PushStyleVar(ImGuiStyleVar_FrameBorderSize, 0.0f);
                    ImGui::PushStyleColor(ImGuiCol_Text,   ImVec4(0.49f, 0.52f, 0.55f, 1.0f));
                }

                char tabLabel[64];
                snprintf(tabLabel, sizeof(tabLabel), "%s %s       ...", subIcons[i], subTitles[i]);
                if (ImGui::Button(tabLabel, ImVec2(tabWidth, 28.0f))) g_State.activeTab = i;

                ImGui::PopStyleColor(3);
                ImGui::PopStyleVar(2);
                if (i < 3) ImGui::SameLine(0, 4.0f);
            }

            ImGui::EndChild();
            ImGui::PopStyleVar(2);
            ImGui::PopStyleColor(2);
        }

        ImGui::Spacing();

        // --- NỘI DUNG CHÍNH (COMBAT: 7 THẺ TRÁI + 6 THẺ PHẢI) ---
        ImGui::BeginChild("##MainContent", ImVec2(0, 0), false);

        if (g_State.activeTab == 0) {
            ImGui::Columns(2, "##CombatCols", false);

            // Cột trái (7 cards)
            RenderToggleCard("Enable External", &g_State.enableExternal);
            RenderToggleCard("Always On",       &g_State.alwaysOn);
            RenderToggleCard("Ignore Knocked",  &g_State.ignoreKnocked);
            RenderToggleCard("No Recoil",       &g_State.noRecoil);
            RenderToggleCard("Silent Aim",      &g_State.silentAim);
            RenderToggleCard("Auto Fire",       &g_State.autoFire);
            RenderToggleCard("No Reload",       &g_State.noReload);

            ImGui::NextColumn();

            // Cột phải (6 cards)
            const char* bones[] = { "Neck", "Head", "Chest", "Pelvis" };
            RenderBoneComboCard("Bone", &g_State.boneIndex, bones, 4);
            RenderFovSliderCard("FOV", &g_State.fovValue, 1.0f, 360.0f);
            RenderToggleCard("Legit Mode",   &g_State.legitMode);
            RenderToggleCard("Aim Lock",     &g_State.aimLock);
            RenderToggleCard("Fast Fire",    &g_State.fastFire);
            RenderToggleCard("Fast Reload",  &g_State.fastReload);

            ImGui::Columns(1);
        }
        else if (g_State.activeTab == 1) {
            ImGui::Columns(2, "##VisualCols", false);
            RenderToggleCard("Esp Line",     &g_State.espLine);
            RenderToggleCard("Esp Box",      &g_State.espBox);
            RenderToggleCard("Esp Health",   &g_State.espHealth);
            ImGui::NextColumn();
            RenderToggleCard("Esp Skeleton", &g_State.espSkeleton);
            RenderToggleCard("Esp Distance", &g_State.espDistance);
            RenderToggleCard("Enemy Player", &g_State.enemyPlayer);
            ImGui::Columns(1);
        }
        else if (g_State.activeTab == 2) {
            BeginCard("##CardKey", 42.0f);
            ImGui::SetCursorPosY(12.0f);
            ImGui::Text("License Key");
            ImGui::SameLine(ImGui::GetWindowWidth() - 240.0f);
            ImGui::TextColored(ImVec4(1, 1, 1, 1), "%s", g_State.fullKey.c_str());
            EndCard();

            BeginCard("##CardHwid", 42.0f);
            ImGui::SetCursorPosY(12.0f);
            ImGui::Text("Device HWID");
            ImGui::SameLine(ImGui::GetWindowWidth() - 240.0f);
            ImGui::TextColored(ImVec4(1, 1, 1, 1), "%s", g_State.deviceHwid.c_str());
            EndCard();
        }
        else if (g_State.activeTab == 3) {
            BeginCard("##CardBuild", 42.0f);
            ImGui::SetCursorPosY(12.0f);
            ImGui::Text("Client Build");
            ImGui::SameLine(ImGui::GetWindowWidth() - 200.0f);
            ImGui::TextColored(ImVec4(1, 1, 1, 1), "%s", g_State.buildVer.c_str());
            EndCard();

            BeginCard("##CardSec", 42.0f);
            ImGui::SetCursorPosY(12.0f);
            ImGui::Text("Security Status");
            ImGui::SameLine(ImGui::GetWindowWidth() - 140.0f);
            ImGui::TextColored(ImVec4(0, 0.9f, 1, 1), "• Undetected");
            EndCard();
        }

        ImGui::EndChild();
        ImGui::End();

        ImGui::PopStyleColor(2);
        ImGui::PopStyleVar(3);
    }

    // ------------------------------------------------------------------------
    // RENDER FRAME CHÍNH (ĐIỀU PHỐI LOGIN -> MENU)
    // ------------------------------------------------------------------------
    void RenderUI(MTKView* view) {
        ImGui_ImplMetal_NewFrame(view.currentRenderPassDescriptor);
        ImGui::NewFrame();

        if (!g_State.isLoggedIn) {
            RenderLoginWindow(&g_State.isLoggedIn);
        } else {
            RenderFloatingPill(&g_State.isMenuOpen);
            if (g_State.isMenuOpen) {
                RenderMainMenu(&g_State.isMenuOpen, &g_State.isLightTheme);
            }
        }

        ImGui::Render();
        ImDrawData* drawData = ImGui::GetDrawData();
        id<MTLCommandBuffer> commandBuffer = [view.commandQueue commandBuffer];
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:view.currentRenderPassDescriptor];
        ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderEncoder);
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
    }
}

