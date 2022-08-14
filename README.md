# flutter_video_player_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Create flutter project with command line
```flutter
flutter create flutter_video_player_app -t app --platforms=android,ios 
```

## 1.  Add the video_player dependency
- This recipe depends on one Flutter plugin: video_player. First, add this dependency to your pubspec.yaml.
```dependencies
dependencies:
  flutter:
    sdk: flutter
  video_player:
```

## 2. Add permissions to your app
- Config for android folder
- Add the following permission to the AndroidManifest.xml file just after the <application> definition. 
- The AndroidManifest.xml file is found at <project root>/android/app/src/main/AndroidManifest.xml.
```android
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>

    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

- Config for ios folder
- For iOS, add the following to the Info.plist file found at <project root>/ios/Runner/Info.plist.
```ios
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```
```warning
Warning: The video_player plugin doesn’t work on iOS simulators. You must test videos on real iOS devices.
```