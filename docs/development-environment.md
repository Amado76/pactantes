# Development Environment

Pactantes targets Android and iOS. The repository contains a minimal Flutter application with native Android and iOS projects. No product features are implemented yet.

## Local toolchain

Prepared on macOS with Apple Silicon:

- Flutter 3.47.7, stable channel, with Dart 3.13.5.
- Xcode 26.6 and CocoaPods 1.16.2.
- Android Studio with its bundled JDK.
- Android SDK at `$HOME/Library/Android/sdk`.
- Android API 36, Build Tools 36.0.0, Platform Tools, Command-line Tools, Emulator, NDK 28.2.13676358, and CMake 3.22.1.
- Android API 36 Google APIs ARM64 system image.

The application declares Dart `^3.13.5` in `pubspec.yaml`. Flutter 3.47.7 was used to generate the initial project.

## Terminal configuration

Add the following to `~/.zshrc` on macOS:

```sh
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
```

Configure Flutter to use the installed SDK and Android Studio JDK:

```sh
flutter config --android-sdk "$HOME/Library/Android/sdk" --jdk-dir "/Applications/Android Studio.app/Contents/jbr/Contents/Home" > /tmp/pactantes-flutter-config.log 2>&1
```

Open a new terminal after updating `~/.zshrc`.

## Validation

Redirect command output to temporary files as required by `AGENTS.md`, check the exit status first, and inspect only relevant excerpts:

```sh
flutter doctor -v > /tmp/pactantes-flutter-doctor.log 2>&1
flutter devices > /tmp/pactantes-flutter-devices.log 2>&1
flutter emulators > /tmp/pactantes-flutter-emulators.log 2>&1
```

The `pactantes_api_36` Android emulator and an iOS simulator are available locally. Start Android with:

```sh
flutter emulators --launch pactantes_api_36 > /tmp/pactantes-emulator-launch.log 2>&1
```

Local validation confirmed Android hardware acceleration and Flutter recognition of both emulator targets. A physical iPhone requires Developer Mode and a trusted USB or wireless connection.

Run dependency resolution from the repository root:

```sh
flutter pub get > /tmp/pactantes-flutter-pub-get.log 2>&1
```

See the [official Android setup guide](https://docs.flutter.dev/platform-integration/android/setup) for platform installation details.
