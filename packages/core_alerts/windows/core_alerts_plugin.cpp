// The Windows layer of core_alerts (architecture §12.3, RA §4.3–4.5; slice
// 2.44), on the channel `fox_drop/core_alerts` (`windows_alerts.dart`):
//
// - playSound {path, loop}, stopSound: a bundled WAV through PlaySound, on
//   the default output device (RA §4.4), looping until stopped.
// - flash {on}: the taskbar button flashes until the window comes to the
//   front, where Windows keeps it from coming forward (RA §4.3).
// - readings {appUserModelId}: the device check's checks 1, 3, 5 and 6
//   (RA §4.5): notifications allowed, started with Windows, the output muted
//   or its volume, and how long the computer waits before it sleeps or
//   hibernates (0: never).
// - setStartup {on}: the current user's Run entry for this executable.
#include "include/core_alerts/core_alerts_plugin_c_api.h"

// clang-format off
#include <windows.h>
#include <mmsystem.h>
#include <mmdeviceapi.h>
#include <endpointvolume.h>
#include <powrprof.h>
// clang-format on

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <initializer_list>
#include <memory>
#include <optional>
#include <string>

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;

// The Run entry's name (one per installation of the restaurant app).
constexpr wchar_t kRunKey[] =
    L"Software\\Microsoft\\Windows\\CurrentVersion\\Run";
constexpr wchar_t kRunValue[] = L"FOX DROP";
// Task Manager's and Settings' startup switch, which leaves the Run value
// in place: an odd first byte means turned off.
constexpr wchar_t kStartupApprovedKey[] =
    L"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\StartupApproved\\Run";

// GUID_SLEEP_SUBGROUP and GUID_STANDBY_TIMEOUT of winnt.h, spelled here so
// no GUID library is needed.
constexpr GUID kSleepSubgroup = {
    0x238c9fa8, 0x0aad, 0x41ed, {0x83, 0xf4, 0x97, 0xbe, 0x24, 0x2c, 0x8f, 0x20}};
constexpr GUID kStandbyTimeout = {
    0x29f6c1db, 0x86da, 0x48c5, {0x9f, 0xdb, 0xf2, 0xb6, 0x7b, 0x1f, 0x44, 0xda}};
// GUID_HIBERNATE_TIMEOUT.
constexpr GUID kHibernateTimeout = {
    0x9d7815a6, 0x7ee4, 0x497e, {0x88, 0x88, 0x51, 0x5a, 0x05, 0xf0, 0x23, 0x64}};

std::wstring Wide(const std::string& utf8) {
  if (utf8.empty()) return std::wstring();
  int size = MultiByteToWideChar(CP_UTF8, 0, utf8.data(),
                                 static_cast<int>(utf8.size()), nullptr, 0);
  std::wstring wide(size, L'\0');
  MultiByteToWideChar(CP_UTF8, 0, utf8.data(), static_cast<int>(utf8.size()),
                      wide.data(), size);
  return wide;
}

const EncodableValue* Argument(const EncodableValue* arguments,
                               const char* name) {
  const auto* map = std::get_if<EncodableMap>(arguments);
  if (!map) return nullptr;
  auto found = map->find(EncodableValue(name));
  return found == map->end() ? nullptr : &found->second;
}

std::string StringArgument(const EncodableValue* arguments, const char* name) {
  const auto* value = Argument(arguments, name);
  const auto* text = value ? std::get_if<std::string>(value) : nullptr;
  return text ? *text : std::string();
}

bool BoolArgument(const EncodableValue* arguments, const char* name) {
  const auto* value = Argument(arguments, name);
  const auto* flag = value ? std::get_if<bool>(value) : nullptr;
  return flag && *flag;
}

// A DWORD under HKEY_CURRENT_USER, if it is there.
std::optional<DWORD> UserDword(const std::wstring& key, const wchar_t* name) {
  DWORD value = 0;
  DWORD size = sizeof(value);
  if (RegGetValueW(HKEY_CURRENT_USER, key.c_str(), name, RRF_RT_REG_DWORD,
                   nullptr, &value, &size) != ERROR_SUCCESS) {
    return std::nullopt;
  }
  return value;
}

// Toasts on for the user and for the app (absent values mean on).
bool NotificationsAllowed(const std::wstring& app_user_model_id) {
  auto all = UserDword(
      L"Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications",
      L"ToastEnabled");
  if (all && *all == 0) return false;
  auto app = UserDword(
      L"Software\\Microsoft\\Windows\\CurrentVersion\\Notifications\\Settings\\" +
          app_user_model_id,
      L"Enabled");
  return !(app && *app == 0);
}

std::wstring ExecutablePath() {
  wchar_t path[MAX_PATH];
  DWORD length = GetModuleFileNameW(nullptr, path, MAX_PATH);
  return std::wstring(path, length);
}

std::wstring RunCommand() { return L"\"" + ExecutablePath() + L"\""; }

bool StartsWithWindows() {
  wchar_t value[MAX_PATH + 3];
  DWORD size = sizeof(value);
  if (RegGetValueW(HKEY_CURRENT_USER, kRunKey, kRunValue, RRF_RT_REG_SZ,
                   nullptr, value, &size) != ERROR_SUCCESS) {
    return false;
  }
  if (_wcsicmp(value, RunCommand().c_str()) != 0) return false;
  BYTE approved[12];
  DWORD approved_size = sizeof(approved);
  if (RegGetValueW(HKEY_CURRENT_USER, kStartupApprovedKey, kRunValue,
                   RRF_RT_REG_BINARY, nullptr, approved,
                   &approved_size) == ERROR_SUCCESS &&
      approved_size > 0 && (approved[0] & 1) == 1) {
    return false;
  }
  return true;
}

bool SetStartup(bool on) {
  HKEY key;
  if (RegOpenKeyExW(HKEY_CURRENT_USER, kRunKey, 0, KEY_SET_VALUE, &key) !=
      ERROR_SUCCESS) {
    return false;
  }
  LSTATUS status;
  if (on) {
    std::wstring command = RunCommand();
    status = RegSetValueExW(
        key, kRunValue, 0, REG_SZ, reinterpret_cast<const BYTE*>(command.c_str()),
        static_cast<DWORD>((command.size() + 1) * sizeof(wchar_t)));
  } else {
    status = RegDeleteValueW(key, kRunValue);
    if (status == ERROR_FILE_NOT_FOUND) status = ERROR_SUCCESS;
  }
  RegCloseKey(key);
  // Turned on here, it is on whatever Task Manager said before.
  RegDeleteKeyValueW(HKEY_CURRENT_USER, kStartupApprovedKey, kRunValue);
  return status == ERROR_SUCCESS;
}

// The default output device's mute and volume (0 to 100); muted when there
// is none.
void ReadOutput(bool* muted, int* volume_percent) {
  *muted = true;
  *volume_percent = 0;
  IMMDeviceEnumerator* enumerator = nullptr;
  if (FAILED(CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr,
                              CLSCTX_ALL, __uuidof(IMMDeviceEnumerator),
                              reinterpret_cast<void**>(&enumerator)))) {
    return;
  }
  IMMDevice* device = nullptr;
  if (SUCCEEDED(enumerator->GetDefaultAudioEndpoint(eRender, eConsole, &device))) {
    IAudioEndpointVolume* endpoint = nullptr;
    if (SUCCEEDED(device->Activate(__uuidof(IAudioEndpointVolume), CLSCTX_ALL,
                                   nullptr,
                                   reinterpret_cast<void**>(&endpoint)))) {
      BOOL mute = TRUE;
      float level = 0;
      if (SUCCEEDED(endpoint->GetMute(&mute)) &&
          SUCCEEDED(endpoint->GetMasterVolumeLevelScalar(&level))) {
        *muted = mute == TRUE;
        *volume_percent = static_cast<int>(level * 100 + 0.5f);
      }
      endpoint->Release();
    }
    device->Release();
  }
  enumerator->Release();
}

// Seconds before the computer sleeps or hibernates under the active plan,
// on mains power or on battery, whichever comes first; 0 when it never does
// or the plan cannot be read.
int SleepAfterSeconds() {
  GUID* scheme = nullptr;
  if (PowerGetActiveScheme(nullptr, &scheme) != ERROR_SUCCESS) return 0;
  DWORD soonest = 0;
  for (const GUID* setting : {&kStandbyTimeout, &kHibernateTimeout}) {
    for (bool on_battery : {false, true}) {
      DWORD seconds = 0;
      DWORD read = on_battery
                       ? PowerReadDCValueIndex(nullptr, scheme, &kSleepSubgroup,
                                               setting, &seconds)
                       : PowerReadACValueIndex(nullptr, scheme, &kSleepSubgroup,
                                               setting, &seconds);
      if (read == ERROR_SUCCESS && seconds > 0 &&
          (soonest == 0 || seconds < soonest)) {
        soonest = seconds;
      }
    }
  }
  LocalFree(scheme);
  return static_cast<int>(soonest);
}

class CoreAlertsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
    auto channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
        registrar->messenger(), "fox_drop/core_alerts",
        &flutter::StandardMethodCodec::GetInstance());
    auto plugin = std::make_unique<CoreAlertsPlugin>(registrar);
    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });
    registrar->AddPlugin(std::move(plugin));
    // The channel lives as long as the engine.
    channel.release();
  }

  explicit CoreAlertsPlugin(flutter::PluginRegistrarWindows* registrar)
      : registrar_(registrar) {}

  ~CoreAlertsPlugin() override { PlaySoundW(nullptr, nullptr, 0); }

 private:
  HWND Window() {
    auto* view = registrar_->GetView();
    return view ? GetAncestor(view->GetNativeWindow(), GA_ROOT) : nullptr;
  }

  void HandleMethodCall(
      const flutter::MethodCall<EncodableValue>& call,
      std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
    const auto& method = call.method_name();
    const auto* arguments = call.arguments();
    if (method == "playSound") {
      std::wstring path = Wide(StringArgument(arguments, "path"));
      DWORD flags = SND_FILENAME | SND_ASYNC | SND_NODEFAULT;
      if (BoolArgument(arguments, "loop")) flags |= SND_LOOP;
      result->Success(EncodableValue(PlaySoundW(path.c_str(), nullptr, flags) == TRUE));
    } else if (method == "stopSound") {
      PlaySoundW(nullptr, nullptr, 0);
      result->Success();
    } else if (method == "flash") {
      FLASHWINFO info = {sizeof(FLASHWINFO)};
      info.hwnd = Window();
      info.dwFlags = BoolArgument(arguments, "on")
                         ? FLASHW_ALL | FLASHW_TIMERNOFG
                         : FLASHW_STOP;
      if (info.hwnd) FlashWindowEx(&info);
      result->Success();
    } else if (method == "readings") {
      bool muted = true;
      int volume = 0;
      ReadOutput(&muted, &volume);
      std::wstring app = Wide(StringArgument(arguments, "appUserModelId"));
      result->Success(EncodableValue(EncodableMap{
          {EncodableValue("notificationsAllowed"),
           EncodableValue(NotificationsAllowed(app))},
          {EncodableValue("startsWithWindows"), EncodableValue(StartsWithWindows())},
          {EncodableValue("outputMuted"), EncodableValue(muted)},
          {EncodableValue("outputVolumePercent"), EncodableValue(volume)},
          {EncodableValue("sleepAfterSeconds"), EncodableValue(SleepAfterSeconds())},
      }));
    } else if (method == "setStartup") {
      result->Success(EncodableValue(SetStartup(BoolArgument(arguments, "on"))));
    } else {
      result->NotImplemented();
    }
  }

  flutter::PluginRegistrarWindows* registrar_;
};

}  // namespace

void CoreAlertsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  CoreAlertsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
