# Pactantes

Minimal Flutter application for Android and iOS. Product features have not been implemented yet.

## Getting started

Use Flutter 3.47.7 with Dart 3.13.5 or a compatible SDK. From the repository root, download dependencies and run the application on a connected device or running simulator:

```sh
flutter pub get > /tmp/pactantes-pub-get.log 2>&1
flutter run > /tmp/pactantes-run.log 2>&1
```

Check each command exit status before inspecting relevant log excerpts.

- `lib/main.dart`: minimal application entry point.
- `android/` and `ios/`: native platform projects.
- `pubspec.yaml` and `pubspec.lock`: dependencies and resolved versions.

Read the [project constitution](docs/CONSTITUTION.md) before making changes. See [development environment](docs/development-environment.md) for local SDK paths and emulator instructions.
