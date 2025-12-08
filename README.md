## 🐦 Flutter & Dart Installation Guide

### Flutter

The fastest way to install Flutter on Mac using the Homebrew package manager.

```bash
brew install flutter
```

### 🔨 Xcode

Required for iOS development and simulator access.

```bash
# Install from App Store or use:
xcode-select --install

# Accept license
sudo xcodebuild -license accept

# Install iOS simulator runtime
xcodebuild -downloadPlatform iOS
```

### 🤖 Android Studio

Required for Android development and emulator access.

1. Download from [developer.android.com](https://developer.android.com/studio)
2. Open the `.dmg` and drag to Applications
3. Launch Android Studio and complete the setup wizard
4. Install Android SDK via **Settings → Languages & Frameworks → Android SDK**

### ⚙️ Android CLI Tools

Command line tools for Android development.

```bash
# Add to your ~/.zshrc or ~/.bash_profile
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Reload shell
source ~/.zshrc
```

### ✅ Verify Installation

Run this command to check if everything is set up correctly and see any missing dependencies.

```bash
flutter doctor
```

### 🩺 Fixing Flutter Doctor Issues

Common fixes for `flutter doctor` warnings.

| Issue                        | Fix                                          |
|------------------------------|----------------------------------------------|
| Android license not accepted | `flutter doctor --android-licenses`          |
| Xcode command line tools     | `xcode-select --install`                     |
| CocoaPods not installed      | `brew install cocoapods`                     |
| No connected devices         | Run `flutter devices` or open simulator      |
| Xcode license not accepted   | `sudo xcodebuild -license accept`            |

### 🛠️ Common Commands

Essential commands you'll use daily when working with Flutter.

| Command                 | Description                              |
|-------------------------|------------------------------------------|
| `flutter doctor`        | Check environment setup and dependencies |
| `flutter create <name>` | Create a new Flutter project             |
| `flutter run`           | Run the app on a connected device        |
| `flutter build ios`     | Build iOS release                        |
| `flutter build apk`     | Build Android APK                        |
| `flutter pub get`       | Install project dependencies             |
| `flutter pub upgrade`   | Upgrade dependencies to latest versions  |
| `flutter clean`         | Delete build files and cache             |
| `flutter devices`       | List all connected devices               |
| `flutter analyze`       | Analyze code for issues                  |
| `flutter test`          | Run unit tests                           |
| `flutter --version`     | Check Flutter version                    |