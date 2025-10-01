# Zentriq 🚀

[![Tests](https://img.shields.io/badge/tests-43%20passing-brightgreen)](https://github.com/AminMemariani/Zentriq)
[![Coverage](https://img.shields.io/badge/coverage-19.8%25-red)](https://github.com/AminMemariani/Zentriq)
[![Business Logic Coverage](https://img.shields.io/badge/business%20logic%20coverage-51.7%25-yellow)](https://github.com/AminMemariani/Zentriq)
[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AminMemariani/Zentriq/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/architecture-MVVM-purple)](https://github.com/AminMemariani/Zentriq)
[![State Management](https://img.shields.io/badge/state%20management-Provider-orange)](https://pub.dev/packages/provider)

A modern Flutter application for the Algorand ecosystem, built with clean architecture principles and comprehensive testing.

## 📱 Features

- **Wallet Management**: View balances, send/receive transactions, and transaction history
- **Token Portfolio**: Track Algorand ecosystem tokens with real-time pricing
- **DeFi Integration**: Access to staking, yield farming, and liquidity pools
- **Ecosystem Explorer**: Discover projects and dApps in the Algorand ecosystem
- **News Feed**: Stay updated with the latest Algorand and crypto news
- **Responsive Design**: Optimized for mobile, tablet, and desktop
- **Dark/Light Mode**: Adaptive theming with Material 3 design

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern:

```
lib/
├── core/           # Core utilities, constants, and shared code
├── data/           # Data layer (repositories, services, models)
├── domain/         # Business logic (entities, use cases, repositories)
├── viewmodels/     # Presentation logic (MVVM ViewModels)
└── views/          # UI layer (screens, widgets)
```

### Key Components

- **Entities**: Core business objects (User, Wallet, Token, etc.)
- **Use Cases**: Business logic operations
- **Repositories**: Data access abstraction
- **ViewModels**: State management with Provider
- **Services**: External API integrations

## 🧪 Testing

The project includes comprehensive test coverage:

- **43 Tests Passing** ✅
- **Unit Tests**: ViewModel logic and business rules
- **Integration Tests**: Provider state management
- **Widget Tests**: UI component testing
- **Mock Testing**: Isolated unit testing with Mockito

### Test Structure

```
test/
├── viewmodels/     # ViewModel unit tests
├── integration/    # Integration tests
├── mocks/         # Mock implementations
└── helpers/       # Test utilities
```

### Coverage Reports

The project provides two types of coverage reports:

1. **Full Coverage Report** (`coverage_report.dart`)
   - Shows coverage for all files in the project
   - Current: 19.8% overall coverage
   - Includes UI components, services, and models

2. **Focused Coverage Report** (`coverage_report_focused.dart`)
   - Shows coverage for business logic only
   - Current: 51.7% business logic coverage
   - Focuses on ViewModels, Use Cases, and core logic
   - More meaningful metric for business logic testing

**Coverage Breakdown:**
- ✅ **ViewModels**: 70-95% coverage (well tested)
- ✅ **Use Cases**: 25-100% coverage (core logic tested)
- ✅ **Core Logic**: Well covered
- ⚠️ **UI Components**: Tested via widget tests
- ⚠️ **Services**: Integration tests recommended

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or higher)
- Dart SDK (3.5.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AminMemariani/Zentriq.git
   cd Zentriq
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Generate coverage report**
   ```bash
   flutter test --coverage
   dart run coverage_report.dart
   ```

5. **Generate focused coverage report (business logic only)**
   ```bash
   dart run coverage_report_focused.dart
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `provider`: State management
- `go_router`: Navigation
- `intl`: Internationalization
- `url_launcher`: External links
- `equatable`: Value equality
- `http`: Network requests
- `xml`: RSS parsing
- `font_awesome_flutter`: Icons

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting
- `mockito`: Mock testing
- `build_runner`: Code generation

## 🎨 Design System

The app uses a consistent design system with:

- **Material 3** design guidelines
- **Adaptive theming** for light/dark modes
- **Responsive layouts** for all screen sizes
- **Custom color palette** optimized for crypto/finance
- **Font Awesome icons** for consistency
- **Rounded cards** with subtle shadows

## 🔧 Development

### Code Generation

Generate mocks for testing:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Linting

Run static analysis:
```bash
flutter analyze
```

### Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 📱 Platform Support

- ✅ **iOS** (iOS 12.0+)
- ✅ **Android** (API 21+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)
- ✅ **Windows** (Windows 10+)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Use conventional commit messages
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Algorand Foundation](https://algorand.foundation/) for the amazing blockchain
- [Flutter Team](https://flutter.dev) for the excellent framework
- [Material Design](https://material.io) for design guidelines
- [Font Awesome](https://fontawesome.com) for beautiful icons

## 📞 Support

If you have any questions or need help, please:

- Open an [issue](https://github.com/AminMemariani/Zentriq/issues)
- Check the [documentation](https://github.com/AminMemariani/Zentriq/wiki)
- Contact the maintainers

---

**Built with ❤️ for the Algorand ecosystem**