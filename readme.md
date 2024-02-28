
# Upgrade Flutter Project 
## Flutter Setup & Notes
## 1. Download SDK (3.19.0)

Download Flutter SDK, extract the "Flutter" folder and put somewhere on your machine 
https://flutter.dev/docs/get-started/install

## 2. Add path

**Windows**

Refer to this tutorial https://www.java.com/en/download/help/path.xml

**Mac OS**

Open or create one the following files:
- ```~/.profile``` (Compatible with MacOS Catalina)
- ```.bash_profile```(Only if your Terminal uses Bash)
add the following line at the bottom.
```
export PATH=$PATH:/flutter/bin
```

**Linux**

Open or create ~/.bash_profile add the following line at the bottom.
```
export PATH=$PATH:/flutter/bin
```

## 3. Check dependencies

```
flutter doctor
```

## 4. Install Xcode (Mac)

https://developer.apple.com/xcode/

## 5. Configure Xcode command line tools (Mac)

```
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## 6. Test iOS Simulator (Mac)

```
open -a Simulator
```

## 7. Install Android Studio

https://developer.android.com/studio

## 8. Install Flutter plugin

## 9. Create virtual device from AVD manager

## 10. Install VSCode Flutter extension

## 11. Clone Aggressor-Adventures App

```
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

## 12. Run Debugger in VSCode

You should now be setup to start editing the lib/main.dart file and build your app


## Setup 

### Android

- update kotlin version and gradle in android/build.gradle file
  
```
ext.kotlin_version = '1.9.10' 
classpath 'com.android.tools.build:gradle:7.3.1'
```
### IOS

Compatible with apps targeting iOS 13 or above.

To upgrade your iOS deployment target to 13.0, you can either do so in Xcode under your Build Settings, or by modifying IPHONEOS_DEPLOYMENT_TARGET in your project.pbxproj directly.

You will also need to update in your Podfile:

`platform :ios, '13.0'`



### Replace dependency in pubspec.yaml file with following code
```
sdk: ">=3.0.3 <4.0.0"
```

```
  cupertino_icons: ^1.0.6
  http:
  sqflite: ^2.3.2
  path_provider: ^2.1.2
  async: ^2.11.0
  flutter_cache_manager: ^3.3.1
  date_format: ^2.0.7
  url_launcher: ^6.1.14
  # multi_image_picker: any
  permission_handler: ^11.0.1
  flutter_aws_s3_client:
  chunked_stream: ^1.4.2
  file_picker:
  cached_network_image: ^3.3.1
  flutter_map:
  percent_indicator: ^4.2.3
  wakelock:
  open_file: ^3.3.2
  flutter_launcher_icons: ^0.13.1
  flutter_html:
  html_editor_enhanced: ^2.5.1
  flutter_slidable: ^3.0.1
  flutter_archive: ^6.0.0
  auto_size_text: ^3.0.0
  image_gallery_saver: ^2.0.3
  flutter_image_compress: ^2.1.0
  youtube_player_iframe:
  webview_flutter: ^4.4.3
  flutter_inappwebview:
  connectivity_plus: ^5.0.2
  flutter_native_splash:
  firebase_messaging:
  firebase_core:
  flutter_app_badger: ^1.5.0
  firebase_core_platform_interface:
  open_mail_app: ^0.4.5
  flutter_bloc: ^8.1.4
  bloc: ^8.1.3
  timezone: ^0.9.2
  vimeo_video_player:
  image_picker: ^1.0.7
  flick_video_player: ^0.5.0
  video_player: ^2.4.0
  ```
### Installation
```
flutter pub get
```
