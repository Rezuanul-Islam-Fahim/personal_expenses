# 💰 Personal Expenses

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/github/license/Rezuanul-Islam-Fahim/personal_expenses?style=for-the-badge)](https://github.com/Rezuanul-Islam-Fahim/personal_expenses/blob/master/LICENSE)
[![Build and Deploy](https://img.shields.io/github/actions/workflow/status/Rezuanul-Islam-Fahim/personal_expenses/build-and-deploy-appetize.yml?style=for-the-badge&logo=github-actions&label=Build%20%26%20Deploy)](https://github.com/Rezuanul-Islam-Fahim/personal_expenses/actions/workflows/build-and-deploy-appetize.yml)

A beautiful and efficient personal expense tracking mobile application built with Flutter 3.24+, featuring local database storage, interactive charts, and responsive design for Android and iOS devices.

<img width="80%" src="screenshots/banner.png">

### 🚀 Try it Live

[![Live Demo](https://img.shields.io/badge/Try%20Live%20Demo-Appetize.io-brightgreen?style=for-the-badge&logo=google-play)](#)
[![Download APK](https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=android)](https://drive.google.com/file/d/1yFQ0ne-uZnVGWa4-omEwpYT20W8gTaFm/view?usp=sharing)

### ⭐ Support this project

[![GitHub stars](https://img.shields.io/github/stars/rezuanul-islam-fahim/personal_expenses?style=social)](https://github.com/Rezuanul-Islam-Fahim/personal_expenses/stargazers) [![GitHub forks](https://img.shields.io/github/forks/rezuanul-islam-fahim/personal_expenses?style=social)](https://github.com/Rezuanul-Islam-Fahim/personal_expenses/network/members) [![GitHub watchers](https://img.shields.io/github/watchers/rezuanul-islam-fahim/personal_expenses?style=social)](https://github.com/Rezuanul-Islam-Fahim/personal_expenses/watchers)

</div>

---

## 📋 Table of Contents

- [Screenshots](#-screenshots)
- [Features](#-features)
- [Getting Started](#-getting-started)
- [CI/CD & Deployment](#-cicd--deployment)
- [Project Structure](#-project-structure)
- [Technologies Used](#-technologies-used)
- [Contributing](#-contributing)
- [License](#-license)

---

## 📱 Screenshots

<div align="center">
<img height="500px" src="screenshots/gif1.gif"> <img height="500px" src="screenshots/gif2.gif">
</div>

---

## ✨ Features

### 📊 Core Functionality
- ✅ **Save Daily Expenses** - Track your spending with title, amount, and date
- ✅ **Interactive Charts** - Visual spending chart for recent 7 days
- ✅ **Delete with Confirmation** - Alert dialogue before deleting expenses
- ✅ **Local Database** - SQLite integration for persistent data storage
- ✅ **Transaction History** - View all your expenses in a scrollable list

### 🎨 User Experience
- ✅ **Beautiful UI** - Modern Material Design with custom theming
- ✅ **Responsive Design** - Optimized for both portrait and landscape modes
- ✅ **Adaptive Layouts** - Different UI arrangements based on orientation
- ✅ **Custom Fonts** - Google Fonts (Open Sans & Quicksand)
- ✅ **Smooth Performance** - Optimized rendering and database queries
- ✅ **Empty State** - Friendly illustration when no transactions exist

### 🚀 Technical Features
- ✅ **Cross-platform** - Works seamlessly on Android and iOS
- ✅ **Offline-first** - All data stored locally
- ✅ **High Performance** - Smooth scrolling and fast operations
- ✅ **Type Safety** - Full Dart type safety
- ✅ **Modular Code** - Reusable widgets and components

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.24.5 or higher)
  ```bash
  flutter --version
  ```
- **Dart SDK** (3.5.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rezuanul-Islam-Fahim/personal_expenses.git
   cd personal_expenses
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```

### Running the App

#### For Android
```bash
flutter run
```

#### Build APK (Android)
```bash
flutter build apk --release
```

---

## 🔄 CI/CD & Deployment

This project includes an automated CI/CD pipeline that builds and deploys the app to Appetize.io for instant browser-based testing.

### 🚀 Automated Deployment Features

- ✅ **Automatic APK Building** - Builds universal release APK on pull requests to master
- ✅ **Appetize Integration** - Deploys to Appetize.io for instant browser testing
- ✅ **Smart Caching** - 3-layer caching (Java, Flutter SDK, Pub dependencies) for 3-5x faster builds
- ✅ **Version Management** - Automatic versioning with build numbers from pubspec.yaml
- ✅ **Artifact Storage** - 30-day APK artifact retention with direct download links
- ✅ **PR Integration** - Automatic deployment info with APK details in pull request comments

### ⚡ Build Performance

| Build Type | Duration | Caching |
|------------|----------|---------|
| First Build | ~10-15 min | Full build with all dependencies |
| Cached Build | ~2-3 min | 3-5x faster with 3-layer smart caching (Java, Flutter, Pub) |

### 📚 Documentation

- **[Architecture Diagram](.github/ARCHITECTURE.md)** - Visual workflow overview and pipeline stages
- **[Contributing Guide](.github/CONTRIBUTING.md)** - Development setup and guidelines

### 🎯 Quick Start CI/CD

1. **Set up Appetize.io account** and get your API token
2. **Add GitHub Secret**: `APPETIZE_API_TOKEN` (Settings → Secrets → Actions)
3. **Create pull request to master branch** - Workflow runs automatically
4. **Check workflow output** - View build results in GitHub Actions tab
5. **Review deployment** - Check PR comments for live preview URL and download link

**That's it!** The workflow automatically builds and deploys your app to Appetize.io on every PR to master.

---

## 📂 Project Structure

```
personal_expenses/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── theme.dart                # App theme configuration
│   ├── global.dart               # Global constants
│   ├── models/                   # Data models
│   │   └── expense.dart          # Expense model
│   └── widgets/                  # Reusable UI components
│       ├── add_transaction.dart  # Add expense form
│       ├── chart.dart            # Weekly chart widget
│       ├── chartbar.dart         # Individual chart bar
│       ├── delete_tx_dialogue.dart
│       ├── no_transaction_image.dart
│       ├── transaction_list.dart # Transaction list view
│       └── tx_list_item.dart     # Single transaction item
├── assets/                       # Static assets
│   ├── fonts/                    # Custom fonts
│   └── images/                   # Images and illustrations
├── .github/                      # GitHub workflows and CI/CD
│   ├── workflows/
│   │   └── build-and-deploy-appetize.yml
│   ├── ARCHITECTURE.md           # CI/CD documentation
│   └── CONTRIBUTING.md           # Contributing guidelines
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
├── pubspec.yaml                  # Project dependencies
└── README.md                     # This file
```

---

## 🛠️ Technologies Used

| Technology | Description |
|------------|-------------|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white) | UI framework |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white) | Programming language |
| ![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white) | Local database |
| ![Material Design](https://img.shields.io/badge/Material%20Design-757575?logo=material-design&logoColor=white) | Design system |
| ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white) | CI/CD automation |

### Key Dependencies
- `intl` (^0.19.0): Internationalization and date formatting
- `sqflite` (^2.3.3): SQLite database plugin
- `path` (^1.9.0): Cross-platform path manipulation
- `cupertino_icons` (^1.0.8): iOS-style icons

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

### How to Contribute

1. **Fork the Project**
2. **Create your Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your Changes** (following [Conventional Commits](https://www.conventionalcommits.org/))
   ```bash
   git commit -m 'feat: add some AmazingFeature'
   ```
4. **Push to the Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Coding Standards
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Write meaningful commit messages (Conventional Commits)
- Add comments for complex logic
- Update documentation as needed

See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for detailed guidelines.

---

## License

```
MIT License

Copyright (c) 2020 Rezuanul Islam Fahim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
