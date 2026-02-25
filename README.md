# SafePath 🛡️

**SafePath** is an AI-powered security companion designed to protect users by simplifying complex legal agreements. It acts as an intelligent layer between you and the fine print, ensuring you never sign away your rights unknowingly.

## ✨ Core Features

- **🔍 Paste-and-Scan Analysis**: Skip the heavy browser load. Simply paste any terms, policies, or agreements into SafePath Lite for instant evaluation.
- **⚡ SPL (SafePath Lite) Model**: A proprietary keyword-based detection engine that identifies high-risk clauses (Data Sharing, Service Termination, Hidden Fees, etc.) in real-time.
- **📈 Risk Scoring**: Get a quantitative "Risk Score" based on the density and severity of detected clauses.
- **📚 Detailed Breakdown**: Deep-dive into each detected clause with simplified explanations of what the legal jargon actually means for you.
- **🎨 Modern Fintech UI**: A premium, state-of-the-art interface built with Flutter, featuring smooth transitions, custom animations, and a centralized design system.
- **💾 Smart Persistence**: Remembers your progress. Once you've completed onboarding and accepted the disclaimer, SafePath takes you straight to the analysis dashboard.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (Latest Stable)
- **Language**: [Dart](https://dart.dev)
- **State Management**: Stateful widgets with efficient lifecycle handling.
- **Persistence**: `shared_preferences` for local state management.
- **Architecture**: Modular structure separating services, pages, and reusable widgets.

## 📂 Project Structure

- `lib/pages/`: Main application screens including `AnalyzeScreen`, `ResultsScreen`, and `VerdictScreen`.
- `lib/services/`: Core logic and helper services like `SPLModelService`.
- `lib/widgets/`: Reusable UI components.
- `lib/pages/onboarding_design.dart`: Centralized theme tokens and design system.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- An Android or iOS device/emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/uchechi09/safepath.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

---

*Made with ❤️ by the SafePath Team*
