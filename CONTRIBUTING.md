# Contributing to Dharma Daily (धर्म दैनिक)

Thank you for your interest in contributing to **Dharma Daily**! We welcome contributions from developers, scholars, researchers, and translators around the world to preserve and digitize timeless Vedic wisdom.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev) (v3.0.0 or higher)
- [Dart SDK](https://dart.dev) (v3.0.0 or higher)
- Android Studio or VS Code with Flutter extension
- Git installed on your machine

### Local Development Setup

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR-USERNAME/Dharma-Daily.git
cd Dharma-Daily

# 2. Install dependencies
flutter pub get

# 3. Run automated tests
flutter test

# 4. Launch app on emulator or physical device
flutter run
```

---

## 🧪 Testing Requirements

Before submitting any Pull Request, ensure that all automated test suites execute cleanly:

```bash
# Run full test suite
flutter test

# Run Panchang ephemeris verification
flutter test test/panchang_test.dart

# Run Data Loader verification
flutter test test/data_test.dart

# Run ID mapping verification
flutter test test/id_mapping_test.dart
```

---

## 📜 Code & Text Guidelines

1. **Devanagari Accuracy**: All Sanskrit shlokas and Devanagari text must follow authentic traditional sources (such as Gita Press Gorakhpur editions).
2. **Astronomical Calculations**: Any modifications to Drik Siddhanta formulas (`tithi`, `nakshatra`, `yoga`, `rahu_kaal`) must include test coverage in `test/panchang_test.dart`.
3. **Clean Architecture**: Maintain separation between `models`, `data` services, and `screens`.
4. **Code Style**: Run `dart format .` and `flutter analyze` to ensure standard Dart formatting without linter errors.

---

## 💬 Community & Discussion

If you find a bug, have a dataset improvement, or want to request a new scripture addition:
- Open a [Bug Report](https://github.com/gangasagar5928/Dharma-Daily/issues/new?template=bug_report.md)
- Open a [Feature Request](https://github.com/gangasagar5928/Dharma-Daily/issues/new?template=feature_request.md)
