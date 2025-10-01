# Zentriq - Flutter MVVM Architecture

This Flutter project follows a clean MVVM (Model-View-ViewModel) architecture pattern with Provider for state management and Material 3 design guidelines.

## 🏗️ Architecture Overview

The project is organized into the following layers:

```
lib/
├── core/                    # Core functionality and utilities
│   ├── constants/          # App constants, colors, themes
│   ├── errors/             # Error handling (failures, exceptions)
│   ├── network/            # Network connectivity utilities
│   └── utils/              # Utility classes (Result, UseCase)
├── data/                   # Data layer
│   ├── datasources/        # Data sources (API, local storage)
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer (business logic)
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Use cases (business logic)
├── viewmodels/             # ViewModels (state management)
├── views/                  # UI layer
│   ├── screens/            # Screen widgets
│   └── widgets/            # Reusable widgets
└── main.dart              # App entry point
```

## 🎨 Design System

### Material 3 Theming
- **Adaptive Theming**: Automatically switches between light and dark themes based on system settings
- **Color Palette**: Modern, soft color scheme with proper contrast ratios
- **Typography**: Material 3 text styles with consistent hierarchy
- **Components**: Styled buttons, cards, inputs, and navigation elements

### Key Features
- ✅ Clean MVVM Architecture
- ✅ Provider State Management
- ✅ Material 3 Design System
- ✅ Adaptive Light/Dark Theme
- ✅ Error Handling with Result Pattern
- ✅ Use Case Pattern for Business Logic
- ✅ Repository Pattern for Data Access
- ✅ Responsive UI Components

## 🔧 Dependencies

- **provider**: ^6.1.2 - State management
- **equatable**: ^2.0.5 - Value equality for objects

## 📱 Platform Support

The app is configured to run on:
- **iOS**: Native iOS styling and behavior
- **Android**: Material Design 3 components
- **Web**: Responsive web layout
- **macOS**: Native macOS styling
- **Linux**: GTK-based styling
- **Windows**: Windows 11 styling

## 🚀 Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Build for production**:
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   flutter build web --release  # Web
   ```

## 🏛️ Architecture Patterns

### MVVM Pattern
- **Model**: Domain entities and data models
- **View**: UI screens and widgets
- **ViewModel**: State management and business logic coordination

### Repository Pattern
- Abstracts data access logic
- Provides a clean interface for data operations
- Handles data source switching (API, cache, local storage)

### Use Case Pattern
- Encapsulates business logic
- Single responsibility principle
- Easy to test and maintain

### Result Pattern
- Type-safe error handling
- Eliminates null safety issues
- Clear success/failure states

## 🎯 Key Components

### Core
- **AppTheme**: Material 3 theming configuration
- **AppColors**: Consistent color palette
- **Result**: Type-safe result handling
- **UseCase**: Base class for business logic

### Example Implementation
The project includes a complete example with:
- User entity and repository
- GetCurrentUser use case
- UserViewModel with Provider
- HomeScreen demonstrating the architecture

## 🔄 State Management Flow

1. **View** triggers an action in **ViewModel**
2. **ViewModel** calls appropriate **UseCase**
3. **UseCase** interacts with **Repository**
4. **Repository** handles data operations
5. **Result** is returned through the chain
6. **ViewModel** updates state and notifies **View**
7. **View** rebuilds with new state

## 🧪 Testing Strategy

The architecture supports:
- **Unit Tests**: Use cases, repositories, viewmodels
- **Widget Tests**: UI components and screens
- **Integration Tests**: End-to-end user flows

## 📈 Scalability

This architecture is designed to scale with:
- Modular folder structure
- Dependency injection with Provider
- Clean separation of concerns
- Type-safe error handling
- Consistent naming conventions

## 🔧 Customization

### Adding New Features
1. Create entity in `domain/entities/`
2. Define repository interface in `domain/repositories/`
3. Implement repository in `data/repositories/`
4. Create use cases in `domain/usecases/`
5. Build viewmodel in `viewmodels/`
6. Design UI in `views/screens/`

### Theming
- Modify `core/constants/app_colors.dart` for colors
- Update `core/constants/app_theme.dart` for component styling
- Add custom themes for specific platforms if needed

## 📚 Best Practices

- Keep views stateless when possible
- Use immutable data models
- Handle errors gracefully with Result pattern
- Follow Material 3 design guidelines
- Write comprehensive tests
- Document complex business logic
- Use meaningful naming conventions

