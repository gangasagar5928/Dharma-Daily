<div align="center">

  <img src="assets/images/app_logo.png" alt="Dharma Daily Logo" width="140" style="border-radius: 24px; box-shadow: 0 8px 24px rgba(255, 179, 0, 0.4);" />

  # 🔱 DHARMA DAILY (धर्म दैनिक)

  ### *॥ धर्मो रक्षति रक्षितः ॥*
  *“Dharma protects those who protect it.”*

  [![Flutter](https://img.shields.io/badge/Flutter-3.44.5-blue.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2.svg?style=for-the-badge&logo=dart)](https://dart.dev)
  [![Android](https://img.shields.io/badge/Android-APK_Ready-3DDC84.svg?style=for-the-badge&logo=android)](https://github.com/gangasagar5928/Dharma-Daily)
  [![License](https://img.shields.io/badge/License-MIT-gold.svg?style=for-the-badge)](LICENSE)
  [![Status](https://img.shields.io/badge/Release-v1.0.0-orange.svg?style=for-the-badge)](#download--installation)

  ---

  <p align="center">
    <b>A modern, beautiful, 100% offline Vedic Panchang, Sacred Scripture Reader & Spiritual Tradition Guide for Android & Web.</b>
  </p>

</div>

<br />

## 🌟 Highlights & Key Features

<table align="center">
  <tr>
    <td width="50%">
      <h3>📅 2026 Astronomical Panchang</h3>
      <ul>
        <li><b>Daily Vedic Calendar:</b> Precise Tithi, Nakshatra, Yoga, and Karana.</li>
        <li><b>Auspicious Timings:</b> Real-time Rahu Kaal, Abhijit Muhurta, Sunrise & Sunset.</li>
        <li><b>Regional Variations:</b> North & South Indian Panchang calculations.</li>
        <li><b>Festival Calendar:</b> Complete guide to Hindu vratas and sacred celebrations.</li>
      </ul>
    </td>
    <td width="50%">
      <h3>📜 Embedded Sacred Scriptures</h3>
      <ul>
        <li><b>Bhagavad Gita:</b> All 18 chapters and 700 Devanagari verses with translation.</li>
        <li><b>Yoga Sutras:</b> 196 sutras of Maharishi Patanjali.</li>
        <li><b>Hanuman Chalisa:</b> 40 chaupais & dohas with devotional commentary.</li>
        <li><b>Upanishads & Niti:</b> Principal Upanishads, Chanakya Niti & Vivekachudamani.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h3>🏛️ The 4 Vedas (चार वेद)</h3>
      <ul>
        <li><b>ऋग्वेद (Rigveda):</b> Agni, Gayatri, Purusha & Nasadiya Suktas.</li>
        <li><b>यजुर्वेद (Yajurveda):</b> Shiva Sankalpa Sukta, Shri Rudram & Isha Upanishad.</li>
        <li><b>सामवेद (Samaveda):</b> Chanting notations & Vedic musical hymns.</li>
        <li><b>अथर्ववेद (Atharvaveda):</b> Prithvi Sukta & Ayurvedic health mantras.</li>
      </ul>
    </td>
    <td width="50%">
      <h3>🚩 18 Mahapuranas (अष्टादश पुराण)</h3>
      <ul>
        <li><b>Full Catalog:</b> Shrimad Bhagavat, Shiva, Vishnu, Garuda, Padma, Skanda, Agni, Bhavishya, Markandeya (Durga Saptashati), Matsya & more.</li>
        <li><b>Devanagari Verses & Kathas:</b> Chapter breakdowns & core shlokas.</li>
        <li><b>100% Offline:</b> Compact JSON architecture embedded in APK.</li>
      </ul>
    </td>
  </tr>
</table>

## 🧮 Astronomical Panchang Architecture & Math

The Panchang engine utilizes a **Hybrid Ephemeris & Drik Siddhanta Engine**:

### 1. Data Origin & Precalculated Ephemeris
- **Ephemeris Dataset:** 455-day dataset covering **Vikram Samvat 2083** (Jan 1, 2026 to Mar 31, 2027) generated from Swiss Ephemeris Drik Siddhanta astronomical data.
- **Geocentric Ecliptic Longitudes:** Contains exact daily Solar (`λ_sun`) and Lunar (`λ_moon`) geocentric longitudes in degrees (`0° to 360°`).

### 2. Drik Siddhanta Mathematical Formulas

| Element | Formula | Range / Definition |
| :--- | :--- | :--- |
| **Lunar Elongation (E)** | `E = (λ_moon - λ_sun) mod 360°` | `0° ≤ E < 360°` |
| **Tithi Index** | `Tithi = ⌊ E / 12° ⌋ + 1` | `1 ≤ Tithi ≤ 30` |
| **Karana Index** | `Karana = ⌊ E / 6° ⌋ + 1` | `1 ≤ Karana ≤ 60` (Half Tithi) |
| **Nakshatra Index** | `Nakshatra = ⌊ λ_moon / 13.3333° ⌋ + 1` | `1 ≤ Nakshatra ≤ 27` (13° 20' per Nakshatra) |
| **Yoga Index** | `Yoga = ⌊ (λ_sun + λ_moon) mod 360° / 13.3333° ⌋ + 1` | `1 ≤ Yoga ≤ 27` (13° 20' per Yoga) |

### 3. Rahu Kaal Octant Calculation
Daytime duration (`T_day = T_sunset - T_sunrise`) is divided into 8 equal octants (`ΔT = T_day / 8`). Rahu Kaal occurs during octant index `k`:

```text
Rahu Kaal Start = T_sunrise + (k - 1) × ΔT
Rahu Kaal End   = T_sunrise + k × ΔT
```

**Weekday Octant Index (k) Mapping:**
- **Monday:** `k = 2` (2nd octant, approx. 07:30 – 09:00 AM)
- **Tuesday:** `k = 7` (7th octant, approx. 03:00 – 04:30 PM)
- **Wednesday:** `k = 5` (5th octant, approx. 12:00 – 01:30 PM)
- **Thursday:** `k = 6` (6th octant, approx. 01:30 – 03:00 PM)
- **Friday:** `k = 4` (4th octant, approx. 10:30 – 12:00 AM)
- **Saturday:** `k = 3` (3rd octant, approx. 09:00 – 10:30 AM)
- **Sunday:** `k = 8` (8th octant, approx. 04:30 – 06:00 PM)

### 4. Regional Amanta vs. Purnimanta System
- **North Indian (Purnimanta):** Month ends on Purnima (Full Moon).
- **South & West Indian (Amanta):** Month ends on Amavasya (New Moon).

<br />

## 🧪 Automated Test Suite

Run automated unit and astronomical tests:

```bash
# Run all tests
flutter test

# Run Panchang astronomical verification test suite
flutter test test/panchang_test.dart

# Run Data Loader verification test suite
flutter test test/data_test.dart
```

- **Bilingual Experience:** Switch seamlessly between **Hindi (हिंदी)** and **English**.
- **Vedic Science Integration:** Discover the scientific logic, health benefits (Ayurveda, circadian rhythm, autophagy), and historical origins behind sacred daily rituals like *Surya Namaskar*, *Upavasa*, *Sandhyavandanam*, and *Deepa Prajwalanam*.
- **Spiritual Micro-Habits:** Daily Shloka picker, bookmarking, and favorites management.

<br />

## 🎨 Design System & Aesthetics

- **Rich Saffron & Gold Theme:** Aesthetic dark mode palette (`#E65100` Saffron, `#FFB300` Radiant Gold, `#880E4F` Deep Crimson).
- **Typography:** Google Fonts **Cinzel** for majestic headers and **Noto Sans Devanagari** for pristine Sanskrit script.
- **Top Vedic Header Banner:** Custom sunrise temple motif featuring Sanskrit motto *॥ धर्मो रक्षति रक्षितः ॥*.

<br />

## 📱 Screenshots & Demo

<div align="center">
  <img src="assets/images/top_bar_banner.png" alt="Dharma Daily Header" width="90%" style="border-radius: 16px;" />
</div>

<br />

## 🚀 Download & Installation

### Option 1: Direct APK Download
Download the prebuilt, optimized ARM64 Android APK directly:
- **[Download dharma-daily.apk](https://github.com/gangasagar5928/Dharma-Daily/raw/main/dharma-daily.apk)** *(18.7 MB)*

### Option 2: Build from Source

```bash
# 1. Clone the repository
git clone https://github.com/gangasagar5928/Dharma-Daily.git

# 2. Navigate to project directory
cd Dharma-Daily

# 3. Install dependencies
flutter pub get

# 4. Run on connected device
flutter run

# 5. Build release APK
flutter build apk --release --target-platform android-arm64
```

<br />

## 🛠️ Tech Stack & Architecture

```
dharma_daily/
├── assets/
│   ├── data/            # Panchang, Scriptures, Vedas & Purans JSON datasets
│   └── images/          # Logo & Top Header Banner graphics
├── lib/
│   ├── data/            # DataService (Asset JSON loader) & PrefsService
│   ├── models/          # Strongly-typed models (Panchang, Scripture, Veda, Puran)
│   ├── screens/         # Home, Panchang Calendar, Library & Detail Sheets
│   ├── theme.dart       # Spiritual M3 Dark/Light Theme configuration
│   ├── widgets/         # Custom Vedic Top Header Banner & UI components
│   └── main.dart        # App entry point & splash screen
└── test/                # Automated widget & data loader tests
```

<br />

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/gangasagar5928/Dharma-Daily/issues).

<br />

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <b>Made with ❤️ for Vedic Heritage & Universal Spiritual Wisdom</b>
</div>
