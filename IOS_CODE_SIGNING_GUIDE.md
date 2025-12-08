# 📱 iOS Code Signing Setup Guide

## 🎯 Quick Overview

To run Flutter apps on a physical iOS device, you need:
- An Apple ID (free or paid Developer account)
- A Development Certificate
- A Provisioning Profile
- A registered device

---

## 🚀 Option 1: Run on Simulator (No Signing Required)

If you just want to test quickly:

```bash
flutter run -d "iPhone 16 Plus"
```

Or list available simulators:

```bash
flutter devices
xcrun simctl list devices
```

---

## 🔐 Option 2: Setup Code Signing for Physical Device

### Step 1: Open Project in Xcode

```bash
open ios/Runner.xcworkspace
```

> ⚠️ Use `.xcworkspace`, not `.xcodeproj`

### Step 2: Sign in with Apple ID

1. Open **Xcode → Settings** (or `⌘ + ,`)
2. Go to **Accounts** tab
3. Click **+** → **Add Apple ID**
4. Sign in with your Apple ID

### Step 3: Configure Signing

1. In Xcode, select **Runner** in the Project Navigator (left sidebar)
2. Select **Runner** under **TARGETS**
3. Go to **Signing & Capabilities** tab
4. Check ✅ **Automatically manage signing**
5. Select your **Team** from the dropdown
    - Personal Team (free Apple ID) → limited to 3 apps, 7-day certificate
    - Paid Developer Account → full capabilities

### Step 4: Set Unique Bundle Identifier

Your bundle ID must be globally unique:

```
com.yourname.pocketwise
```

Change it in **Signing & Capabilities** → **Bundle Identifier**

### Step 5: Register Your Device

**Automatic (recommended):**
- Connect your iPhone via USB
- Xcode will prompt to register it automatically

**Manual:**
1. Get your device UDID: **Xcode → Window → Devices and Simulators**
2. Add it at [developer.apple.com](https://developer.apple.com) (requires paid account)

### Step 6: Trust the Certificate on iPhone

First build will fail on device with an "Untrusted Developer" error.

On your iPhone:
1. Go to **Settings → General → VPN & Device Management**
2. Find your developer certificate
3. Tap **Trust**

### Step 7: Run Your App

```bash
flutter run
```

---

## 🆓 Free vs Paid Apple Developer Account

| Feature | Free (Personal Team) | Paid ($99/year) |
|---------|---------------------|-----------------|
| Simulator testing | ✅ | ✅ |
| Physical device testing | ✅ (7-day limit) | ✅ |
| App Store distribution | ❌ | ✅ |
| Push Notifications | ❌ | ✅ |
| App provisioning limit | 3 apps | Unlimited |
| Certificate validity | 7 days | 1 year |

---

## 🐛 Common Issues

### "No Development Team"
- Sign into Xcode with your Apple ID first
- Check **Signing & Capabilities** → **Team**

### "Bundle ID already in use"
- Change to a unique bundle ID like `com.yourname.pocketwise.dev`

### "Device not registered"
- Connect device and let Xcode register it
- Or manually add UDID in Apple Developer portal

### "Untrusted Developer"
- On iPhone: **Settings → General → VPN & Device Management → Trust**

### Certificate Expired (Free Account)
- Free certificates expire every 7 days
- Just rebuild in Xcode to get a new one

---

## 📋 Quick Checklist

- [ ] Apple ID signed into Xcode
- [ ] Team selected in Signing & Capabilities
- [ ] Unique Bundle ID set
- [ ] "Automatically manage signing" enabled
- [ ] Device connected and registered
- [ ] Certificate trusted on device

---

## 🔗 Resources

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Apple Developer Program](https://developer.apple.com/programs/)