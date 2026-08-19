# Dharma Daily Technical Wiki & Architecture Reference

> **Version:** 1.0.0 Production | **Framework:** Flutter 3.x / Dart 3.x | **Platform:** Android, iOS, Web
>
> This wiki is the technical reference for the Dharma Daily application, an offline-first Vedic Panchang, Sacred Scripture Reader, and Spiritual Tradition Engine.

---

## Table of Contents

1. [Architectural Overview](#1-architectural-overview)
2. [Data Architecture & Schemas](#2-data-architecture--schemas)
3. [Drik Siddhanta Panchang Mathematical Model](#3-drik-siddhanta-panchang-mathematical-model)
4. [Offline Storage & State Management](#4-offline-storage--state-management)
5. [Cloud PDF Streaming Engine (`DrivePdfScreen`)](#5-cloud-pdf-streaming-engine-drivepdfscreen)
6. [UI Layer & Component Breakdown](#6-ui-layer--component-breakdown)
7. [Theming & Typography System](#7-theming--typography-system)
8. [Testing & Verification Protocol](#8-testing--verification-protocol)
9. [Build & CI/CD Pipeline](#9-build--cicd-pipeline)

---

## 1. Architectural Overview

Dharma Daily is built as a modular, offline-first mobile application leveraging Flutter's reactive component model.

```
┌──────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│   HomeScreen  │  CalendarScreen  │ LibraryScreen │ Sheets │
├──────────────────────────────────────────────────────────┤
│                     Widgets & Theme                      │
│   VedicBanner │ ShlokaCard │ PanchangExpander │ M3 Theme │
├──────────────────────────────────────────────────────────┤
│                  Domain / Model Layer                    │
│   PanchangDay │ Festival   │ ScriptureItem │ Veda/Puran  │
├──────────────────────────────────────────────────────────┤
│                    Data Access Layer                     │
│   DataService (JSON Parser)  │ PrefsService (SharedPreferences) │
│   PdfCacheManager (Drive HTTP Streams & Local LRU Cache) │
└──────────────────────────────────────────────────────────┘
```

### Core Architecture Principles:
- **Zero Network Dependency for Core Operations:** All 455 days of Panchang data, 700 Bhagavad Gita shlokas, 196 Patanjali Yoga Sutras, Hanuman Chalisa, 4 Vedas summaries, and 18 Mahapuranas metadata are bundled locally in pre-compiled JSON format.
- **Lazy Deserialization:** Asset files are parsed into typed immutable models on-demand through `DataService` singleton.
- **LRU Cloud PDF Cache:** High-fidelity original manuscript scans (Vedas/Puranas) stream on-demand from Google Drive endpoints and cache to the device sandbox.

---

## 2. Data Architecture & Schemas

The application data resides under `assets/data/`:
- `panchang_2026.json`: Complete 455-day astronomical calendar with Tithi, Nakshatra, Yoga, Karana, Rahu Kaal, Yamaganda, Gulika, and Abhijit Muhurta.
- `festivals.json`: Comprehensive database of Sanatana festivals, Vrats, Jayantis, and Ekadashis.
- `scriptures.json`: Full verse-by-verse Gita (18 chapters, 700 verses), Yoga Sutras (4 Padas, 196 sutras), and Hanuman Chalisa with Devanagari, IAST transliteration, and English meanings.
- `vedas_full.json`: Rigveda, Yajurveda, Samaveda, Atharvaveda core structure, Samhitas, Brahmanas, Aranyakas, and Upanishad mappings.
- `puranas_full.json`: 18 Mahapuranas with categorization (Sattva, Rajas, Tamas), sloka counts, and primary philosophical teachings.
- `traditions.json`: Scientific rationales and health benefits behind daily Vedic rituals (Surya Namaskar, Tilak, Sandhyavandanam, Fasting).
- `drive_sources.json`: Direct verified cloud storage IDs for authentic PDF manuscripts.

---

## 3. Drik Siddhanta Panchang Mathematical Model

The Panchang calculations follow the modern **Drik Ganita (Drik Siddhanta)** astronomical system with true planetary positions:
- **Tithi:** Longitudinal separation between Sun and Moon in steps of 12 degrees:
  $$\text{Tithi} = \left\lfloor \frac{\lambda_{\text{Moon}} - \lambda_{\text{Sun}}}{12^\circ} \right\rfloor \pmod{30} + 1$$
- **Nakshatra:** Moon's ecliptic longitude divided into 27 equal arcs of 13 degrees 20 minutes (800 minutes):
  $$\text{Nakshatra} = \left\lfloor \frac{\lambda_{\text{Moon}}}{13^\circ 20'} \right\rfloor + 1$$
- **Yoga:** Sum of Sun and Moon ecliptic longitudes in units of 13 degrees 20 minutes:
  $$\text{Yoga} = \left\lfloor \frac{\lambda_{\text{Moon}} + \lambda_{\text{Sun}}}{13^\circ 20'} \right\rfloor \pmod{27} + 1$$
- **Karana:** Half-Tithi span of 6 degrees:
  $$\text{Karana} = \left\lfloor \frac{\lambda_{\text{Moon}} - \lambda_{\text{Sun}}}{6^\circ} \right\rfloor \pmod{60} + 1$$

---

## 4. Offline Storage & State Management

- `PrefsService`: Encapsulates `SharedPreferences` for user bookmarking, favorites, reading position, and regional sunrise calibration offsets.
- `DataService`: Singleton provider that loads and caches parsed collections in memory with deterministic thread-safe access.

---

## 5. Cloud PDF Streaming Engine (`DrivePdfScreen`)

Original high-resolution PDF manuscripts are loaded via `DrivePdfScreen`:
- Validates Google Drive direct-download endpoints.
- Verifies MIME-types and content length.
- Utilizes streaming chunked storage to write to local application support directory.
- Displays progress indicators during background download and seamlessly transitions to full-screen PDF view.

---

## 6. UI Layer & Component Breakdown

- `HomeScreen`: Real-time Panchang overview card, current Tithi/Nakshatra progress indicators, Daily Shloka of the Day, and upcoming Vrats.
- `CalendarScreen`: Interactive calendar month grid view with color-coded Ekadashi/Purnima/Amavasya indicators and expandable day breakdown.
- `LibraryScreen`: 4-tab sacred text explorer for Bhagavad Gita, 4 Vedas, 18 Mahapuranas, and Vedic Traditions.
- `DetailSheets`: Modal bottom sheets for distraction-free reading, audio recitation playback, and Sanskrit verse copying.

---

## 7. Theming & Typography System

Configured in `lib/theme.dart` adhering to Material Design 3:
- **Spiritual Light Palette:** Deep Ochre / Saffron primary (`#FF9933`), warm temple gold secondary, cream parchment background.
- **Meditative Dark Palette:** Midnight navy background, radiant amber primary, muted sandalwood surfaces.
- **Typography:** Google Fonts `Noto Sans Devanagari` and `Cinzel` for classical Vedic headers.

---

## 8. Testing & Verification Protocol

The test suite under `test/` ensures complete structural integrity:
- `panchang_test.dart`: Validates Drik Siddhanta computations across all 455 days in the dataset.
- `data_test.dart`: Validates JSON schema adherence for scriptures, Vedas, and Puranas.
- `id_mapping_test.dart`: Asserts 1-to-1 alignment between metadata IDs and cloud PDF references.
- `widget_test.dart`: Full UI smoke testing and navigation lifecycle verification.

Run tests:
```bash
flutter test
```

---

## 9. Build & CI/CD Pipeline

Automated by GitHub Actions in `.github/workflows/ci.yml`:
- **Trigger:** Pushes and pull requests to `main`.
- **Jobs:**
  1. Flutter environment configuration (`subosito/flutter-action`).
  2. Static analysis (`flutter analyze --no-fatal-infos`).
  3. Unit and integration test suite execution (`flutter test`).
  4. Release Android APK artifact assembly (`flutter build apk --release`).