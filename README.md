# 📄 Acad Helper - Smart Document Scanner + AI Summarizer

An intelligent document processing system that captures images, extracts text via OCR, and generates concise summaries using AI.

## 🚀 Getting Started

### 📦 Prerequisites
- **Flutter SDK**
- **Tesseract OCR Engine** (for Linux development):
  - Linux: `sudo apt-get install tesseract-ocr`
- **Firebase Account**: This app uses Firebase for backend services.

---

### 📱 Frontend Setup (Flutter)
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. **Configure Firebase**:
   - Run `flutterfire configure` OR
   - Manually add `google-services.json` to `android/app/` and `GoogleService-Info.plist` to `ios/Runner/`.
4. Run the application:
   ```bash
   flutter run
   ```

## 🛠️ Tech Stack
- **Flutter**: Mobile UI & Logic
- **Google ML Kit**: On-device OCR
- **Gemini API**: AI Summarization
- **Firebase**: Backend Persistence & Auth
