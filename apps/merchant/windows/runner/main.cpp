#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <string>

#include "flutter_window.h"
#include "utils.h"

namespace {

// «تطبيق المطعم», escaped so the compiler needs no source encoding.
constexpr wchar_t kTitle[] =
    L"\u062A\u0637\u0628\u064A\u0642 \u0627\u0644\u0645\u0637\u0639\u0645";

// core_alerts' "Start with Windows" entry (core_alerts_plugin.cpp).
constexpr wchar_t kRunKey[] =
    L"Software\\Microsoft\\Windows\\CurrentVersion\\Run";
constexpr wchar_t kStartupApprovedKey[] =
    L"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\StartupApproved\\Run";
constexpr wchar_t kRunValue[] = L"FOX DROP";

std::wstring ExecutablePath() {
  wchar_t path[MAX_PATH];
  DWORD length = ::GetModuleFileNameW(nullptr, path, MAX_PATH);
  return std::wstring(path, length);
}

// Slice 2.44: Velopack runs the app with --veloapp-install, -updated,
// -obsolete or -uninstall and waits for it to exit. Nothing starts then;
// the uninstall also removes "Start with Windows".
bool VelopackHook(const wchar_t* command_line) {
  std::wstring line(command_line ? command_line : L"");
  if (line.find(L"--veloapp-") == std::wstring::npos) return false;
  if (line.find(L"--veloapp-uninstall") != std::wstring::npos) {
    ::RegDeleteKeyValueW(HKEY_CURRENT_USER, kRunKey, kRunValue);
    ::RegDeleteKeyValueW(HKEY_CURRENT_USER, kStartupApprovedKey, kRunValue);
  }
  return true;
}

// RA §4.3 (slice 2.44): one copy per installation, since the app hides in
// the tray and two copies would share one session and use its refresh token
// up. A second start shows the running window and exits. The mutex is named
// by the executable's path, so staging and production installs stay apart.
HANDLE SingleInstance() {
  std::wstring name = L"Local\\FOXDROP-" + ExecutablePath();
  for (size_t i = 6; i < name.size(); ++i) {
    if (name[i] == L'\\') name[i] = L'/';
  }
  HANDLE mutex = ::CreateMutexW(nullptr, TRUE, name.c_str());
  if (mutex && ::GetLastError() == ERROR_ALREADY_EXISTS) {
    HWND running = ::FindWindowW(L"FLUTTER_RUNNER_WIN32_WINDOW", kTitle);
    if (running) {
      ::ShowWindow(running, ::IsIconic(running) ? SW_RESTORE : SW_SHOW);
      ::SetForegroundWindow(running);
    }
    ::CloseHandle(mutex);
    return nullptr;
  }
  return mutex;
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  if (VelopackHook(command_line)) return EXIT_SUCCESS;
  HANDLE instance_mutex = SingleInstance();
  if (!instance_mutex) return EXIT_SUCCESS;

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(kTitle, origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  ::CloseHandle(instance_mutex);
  return EXIT_SUCCESS;
}
