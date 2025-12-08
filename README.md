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

--- 

## Flutter Debug with IntelliJ Attach

### 🚀 Step 1: Run Flutter from Terminal

```bash
flutter run -d <device-id>
```

**Example with simulator:**
```bash
flutter run --start-paused -d 1CFD39A0-86A0-49BA-A678-363AD246937F
```

**Find your device ID:**
```bash
flutter devices
```

### 🔗 Step 2: Copy the Dart VM Service URL

After the app launches, look for this line in terminal output:

```
The Dart VM service is listening on http://127.0.0.1:XXXXX/YYYYY/
```

📋 Copy this URL.

### ⚙️ Step 3: Create Dart Remote Debug Configuration

1. Open IntelliJ
2. Go to **Run → Edit Configurations**
3. Click **+** (Add New Configuration)
4. Select **Dart Remote Debug**
5. Name it (e.g., `Flutter Attach`)
6. Leave defaults
7. Click **Apply** → **OK**

### 🎯 Step 4: Attach Debugger

1. Select **Flutter Attach** (or your config name) from the run dropdown
2. Click the **Debug** button 🐛
3. Paste the Dart VM service URL when prompted
4. Click **OK**

---

## Mock Server

Mock server using [json-server](https://github.com/typicode/json-server) to simulate the backend apis endpoints.

### Prerequisites

- Node.js installed
- json-server v0.17.x installed globally:

```bash
npm install -g json-server@0.17.4
```

### Running

```bash
# Starts the mocks server
json-server --watch mock/db.json --routes mock/routes.json --port 8080
# Starts ngrok pointing to the mock server
ngrok http --url=convenient-judi-spectrochemical.ngrok-free.dev 8080
```

### Endpoints

| Method | Endpoint                            | Description                  |
|--------|-------------------------------------|------------------------------|
| GET    | `/api/accounts/{iban}`              | Get account by IBAN          |
| GET    | `/api/accounts/{iban}/balances`     | Get balances for account     |
| GET    | `/api/accounts/{iban}/transactions` | Get transactions for account |

### Example Requests

```bash
# Get account
curl http://localhost:8080/api/accounts/DE89370400440532013000
# Get balances
curl http://localhost:8080/api/accounts/DE89370400440532013000/balances
# Get transactions
curl http://localhost:8080/api/accounts/DE89370400440532013000/transactions
```