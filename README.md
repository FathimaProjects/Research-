# Citrus AI — Mobile Recognition 

An intelligent mobile application developed as an 8th-semester university research prototype. Citrus AI classifies five distinct citrus fruit species using an on-device fine-tuned MobileNetV2 convolutional neural network running locally via TensorFlow Lite, retrieves verified nutritional and botanical health data, and provides curated culinary suggestions.

---

## 🍊 Supported Citrus Varieties
1. **Sweet Orange** (*Citrus sinensis*)
2. **Mandarin / Tangerine** (*Citrus reticulata*)
3. **Lemon** (*Citrus limon*)
4. **Key / Persian Lime** (*Citrus aurantiifolia*)
5. **Kaffir / Makrut Lime** (*Citrus hystrix*)

---

## 📱 Application Flow
```
Splash Screen ──► Welcome Screen (Continue as Guest) ──► Home Screen
                                                             │
                              ┌──────────────────────────────┴──────────────────────────────┐
                              ▼                                                             ▼
                     [Take a Photo]                                                 [Choose Image]
                              │                                                             │
                              └──────────────────────────────┬──────────────────────────────┘
                                                             ▼
                                                   [Image Preview Screen]
                                                             │ (TFLite MobileNetV2 Inference)
                                              ┌──────────────┴──────────────┐
                                              ▼ (Confidence >= 60%)         ▼ (Confidence < 60%)
                                   [Recognition Result]            [Unsupported Result]
                                              │
                      ┌───────────────────────┼───────────────────────┐
                      ▼                       ▼                       ▼
            [Nutrition Values]     [Allergy & Health Info]    [Culinary Ideas]
          (Verified USDA Data)     (Precautions & Ref.)     (External Video Links)
```

---

## 🛠️ Architecture & Technologies
* **Framework:** Flutter 3.47.9 / Dart 3.13.7
* **On-Device Inference:** TensorFlow Lite (`tflite_flutter` v0.12.1) running `assets/models/model.tflite`
* **Image Preprocessing:** `image` package (resizing to 224x224, float normalization)
* **Image Capture & Gallery:** `image_picker`
* **Typography & Palette:** Google Fonts (Plus Jakarta Sans) with custom botanical palette:
  * Forest Green (`#173D32`)
  * Primary Green (`#347653`)
  * Soft Sage (`#E6EFE5`)
  * Warm Cream (`#FAF8F1`)
  * Citrus Orange (`#F2A544`)
* **Secure Gemini Backend Proxy:** Firebase Cloud Function (`backend/functions/index.js`) isolating API credentials from the mobile client.
* **External Links:** `url_launcher` for verified YouTube video demonstrations and recipes.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.24+ / 3.47+)
* Java OpenJDK 17
* Android SDK (API 34/36)

### Run the App
```bash
# 1. Clone repository and checkout development branch
git clone -b app-development https://github.com/FathimaProjects/Research-.git
cd Research-

# 2. Install dependencies
flutter pub get

# 3. Run on connected Android phone or emulator
flutter run
```
