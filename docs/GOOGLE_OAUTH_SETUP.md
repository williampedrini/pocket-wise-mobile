# Google OAuth Setup for PocketWise

This guide walks you through setting up Google OAuth authentication for the PocketWise mobile application.

## Prerequisites

- Google Account
- Access to [Google Cloud Console](https://console.cloud.google.com/)
- Flutter development environment configured
- Xcode (for iOS development)
- Android Studio (for Android development)

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click on the project dropdown at the top of the page
3. Click **New Project**
4. Enter a project name (e.g., "PocketWise")
5. Click **Create**
6. Wait for the project to be created and select it

## Step 2: Configure OAuth Consent Screen

1. In the Google Cloud Console, navigate to **APIs & Services** > **OAuth consent screen**
2. Select **External** user type (unless you have a Google Workspace organization)
3. Click **Create**
4. Fill in the required fields:
   - **App name**: PocketWise
   - **User support email**: Your email address
   - **Developer contact information**: Your email address
5. Click **Save and Continue**
6. On the **Scopes** page, click **Add or Remove Scopes**
7. Add the following scopes:
   - `email`
   - `profile`
   - `openid`
8. Click **Update** and then **Save and Continue**
9. On the **Test users** page, add any test users if needed (required while app is in testing mode)
10. Click **Save and Continue**
11. Review the summary and click **Back to Dashboard**

## Step 3: Create OAuth 2.0 Credentials

### For iOS

1. Navigate to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. Select **iOS** as the application type
4. Fill in the details:
   - **Name**: PocketWise iOS
   - **Bundle ID**: `com.pocketwise.pocketWise` (must match your iOS app's bundle identifier)
5. Click **Create**
6. Note down the **Client ID** (format: `XXXX.apps.googleusercontent.com`) 

### For Android

1. Click **Create Credentials** > **OAuth client ID**
2. Select **Android** as the application type
3. Fill in the details:
   - **Name**: PocketWise Android
   - **Package name**: `com.pocketwise.mobile` (must match your Android app's package name)
   - **SHA-1 certificate fingerprint**: See [Getting SHA-1 Fingerprint](#getting-sha-1-fingerprint) below
4. Click **Create**
5. Note down the **Client ID**

### For Web (Optional - for backend/testing)

1. Click **Create Credentials** > **OAuth client ID**
2. Select **Web application** as the application type
3. Fill in the details:
   - **Name**: PocketWise Web
   - **Authorized JavaScript origins**: Add your domains
   - **Authorized redirect URIs**: Add your callback URLs
4. Click **Create**
5. Note down both the **Client ID** and **Client Secret**

## Step 4: Getting SHA-1 Fingerprint

### Debug Keystore (for development)

```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Release Keystore (for production)

```bash
keytool -list -v -keystore /path/to/your/release-keystore.jks -alias your-key-alias
```

Copy the SHA-1 fingerprint from the output (looks like: `XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX`)

## Step 5: Configure the Flutter Application

### iOS Configuration

1. Open `ios/Runner/Info.plist`
2. Add the following entries (replace `YOUR_CLIENT_ID` with your iOS Client ID):

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
<key>GIDClientID</key>
<string>YOUR_CLIENT_ID.apps.googleusercontent.com</string>
```

> **Note**: The URL scheme is the reversed client ID (without `.apps.googleusercontent.com`)

### Android Configuration

1. Create or update `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="default_web_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
</resources>
```

> **Note**: For Android, use the **Web** client ID if you have one, or the Android client ID.

## Step 6: Add the Flutter Dependency

In `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^6.2.1
```

Run:

```bash
flutter pub get
```

## Step 7: Implement Google Sign-In

The application already has Google Sign-In implemented in:

- `lib/features/auth/data/datasources/auth_datasource.dart` - Google Sign-In logic
- `lib/features/auth/presentation/pages/login_page.dart` - Login UI
- `lib/features/auth/presentation/bloc/auth_bloc.dart` - State management

## Troubleshooting

### Common Issues

#### iOS: "Your app is missing support for the following URL schemes"

Ensure the `CFBundleURLSchemes` in `Info.plist` contains the reversed client ID.

#### Android: Sign-in fails silently

1. Verify the SHA-1 fingerprint is correct in Google Cloud Console
2. Make sure the package name matches exactly
3. Check that you're using the correct client ID in `strings.xml`

#### "Sign in failed" or "DEVELOPER_ERROR"

1. Double-check all client IDs are correct
2. Verify OAuth consent screen is properly configured
3. Ensure all SHA-1 fingerprints (debug and release) are added

#### iOS: App crashes on sign-in

Make sure you've run `pod install` in the `ios` directory:

```bash
cd ios && pod install && cd ..
```

### Debug Mode

To enable debug logging for Google Sign-In, you can check the console output when running:

```bash
flutter run --verbose
```

## Security Best Practices

1. **Never commit client secrets** to version control
2. **Use environment variables** or secure storage for sensitive configuration
3. **Restrict API keys** in Google Cloud Console to specific apps/platforms
4. **Enable only required scopes** (email, profile, openid)
5. **Regularly rotate credentials** if compromised
6. **Monitor usage** in Google Cloud Console for suspicious activity

## Current Configuration

The application is currently configured with:

- **iOS Client ID**: `687531952008-uoec0erisovn423lkbsljk1ahgr1t84g.apps.googleusercontent.com`
- **Bundle ID**: `com.pocketwise.pocketWise`
- **Android Package**: `com.pocketwise.mobile`

## References

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com/)
- [OAuth 2.0 for Mobile & Desktop Apps](https://developers.google.com/identity/protocols/oauth2/native-app)
- [Google Identity Services](https://developers.google.com/identity)
