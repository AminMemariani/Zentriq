# Zentriq - Algorand Wallet App Structure

## 🏗️ Complete MVVM Architecture Implementation

The Zentriq app now features a comprehensive MVVM architecture with navigation state management, Material 3 design, and five core functional areas for Algorand ecosystem interaction.

## 📱 App Structure Overview

### Core Navigation Pages
- **Wallet** - Core wallet functions (balance, send, receive)
- **DeFi** - Integrations, staking, yield farming
- **Ecosystem** - Latest Algorand projects & dApps
- **News** - Crypto/Algorand news feed
- **Tokens** - Token list and top performers

### Architecture Components

```
lib/
├── app.dart                    # Main app with navigation setup
├── main.dart                   # App entry point
├── core/                       # Core functionality
│   ├── constants/
│   │   ├── app_colors.dart     # Material 3 color palette
│   │   ├── app_theme.dart      # Light/dark theme configuration
│   │   ├── app_constants.dart  # App-wide constants
│   │   ├── navigation_constants.dart # Route names and indices
│   │   └── app_enums.dart      # Type-safe enums
│   ├── errors/                 # Error handling
│   ├── network/                # Network utilities
│   └── utils/                  # Result pattern, UseCase base
├── data/                       # Data layer
│   ├── models/                 # Data models
│   └── repositories/           # Repository implementations
├── domain/                     # Business logic
│   ├── entities/               # Business entities
│   ├── repositories/           # Repository interfaces
│   └── usecases/               # Use cases
├── viewmodels/                 # State management
│   ├── main_viewmodel.dart     # Navigation state management
│   └── user_viewmodel.dart     # User state management
└── views/                      # UI layer
    ├── screens/                # Page screens
    │   ├── wallet_screen.dart      # Wallet functionality
    │   ├── defi_screen.dart        # DeFi features
    │   ├── ecosystem_screen.dart   # Ecosystem projects
    │   ├── news_screen.dart        # News feed
    │   └── tokens_screen.dart      # Token management
    └── widgets/                # Reusable components
        ├── base_screen.dart        # Base screen template
        ├── bottom_navigation_bar.dart # Navigation bar
        ├── loading_widget.dart     # Loading states
        └── error_widget.dart       # Error handling
```

## 🎯 Key Features Implemented

### 1. **MainViewModel Navigation Management**
- Centralized navigation state management
- Type-safe page switching with enums
- Loading and error state handling
- Reactive UI updates with Provider

### 2. **Bottom Navigation Bar**
- Material 3 NavigationBar component
- Five main sections with appropriate icons
- Smooth transitions between pages
- Consistent with Material Design guidelines

### 3. **Wallet Screen**
- **Balance Display**: Total balance with USD conversion
- **Send/Receive**: Quick action buttons for transactions
- **Transaction History**: Recent transaction list
- **Real-time Updates**: Mock data with loading states

### 4. **DeFi Screen**
- **Overview Stats**: TVL and APY earned
- **Staking Options**: Governance and liquid staking
- **Yield Farming**: ALGO/USDC and ALGO/ETH pools
- **APY Display**: Competitive yield rates

### 5. **Ecosystem Screen**
- **Featured Projects**: Algorand Foundation, Pact, AlgoFi
- **Categories**: DeFi, NFTs, Gaming, Tools
- **Latest dApps**: Tinyman, Yieldly, AlgoStake
- **Interactive Cards**: Tap to explore projects

### 6. **News Screen**
- **Category Filters**: All, Algorand, DeFi, NFTs, Regulation
- **Featured Articles**: Large format with images
- **Latest News**: Compact list with timestamps
- **Source Attribution**: Publisher and time information

### 7. **Tokens Screen**
- **Portfolio Overview**: Total value and 24h change
- **Top Performers**: Best performing tokens
- **All Tokens**: Complete token list with prices
- **Market Stats**: Market cap, volume, supply data

## 🔧 Technical Implementation

### State Management
```dart
// MainViewModel manages navigation state
class MainViewModel extends ChangeNotifier {
  AppPage _currentPage = AppPage.wallet;
  int _currentIndex = 0;
  
  void changePage(AppPage page) {
    _currentPage = page;
    _currentIndex = page.index;
    notifyListeners();
  }
}
```

### Navigation Setup
```dart
// App.dart handles routing and providers
class ZentriqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainViewModel>(...),
        // Other providers...
      ],
      child: MaterialApp(
        home: const MainNavigationScreen(),
        onGenerateRoute: _generateRoute,
      ),
    );
  }
}
```

### Material 3 Theming
- **Adaptive Themes**: Automatic light/dark mode switching
- **Color System**: Consistent Material 3 color palette
- **Component Styling**: Cards, buttons, navigation elements
- **Typography**: Material 3 text styles

## 🚀 Usage Examples

### Adding New Pages
1. Add new enum value to `AppPage`
2. Create screen widget in `views/screens/`
3. Add route to `_generateRoute()` in `app.dart`
4. Update navigation bar destinations

### Customizing Themes
```dart
// Modify colors in app_colors.dart
static const Color primary = Color(0xFF6750A4);

// Update theme in app_theme.dart
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(...),
  );
}
```

### State Management
```dart
// Access MainViewModel in widgets
Consumer<MainViewModel>(
  builder: (context, viewModel, child) {
    return Text('Current page: ${viewModel.currentPage.title}');
  },
)
```

## 📊 App Flow

1. **App Launch** → MainNavigationScreen loads
2. **Default Page** → Wallet screen displays
3. **Navigation** → User taps bottom nav items
4. **State Update** → MainViewModel updates current page
5. **UI Refresh** → New screen renders with data
6. **User Interaction** → Actions trigger ViewModel methods

## 🧪 Testing

- **Widget Tests**: Screen rendering and navigation
- **Unit Tests**: ViewModel state management
- **Integration Tests**: End-to-end user flows
- **All Tests Passing**: ✅ Comprehensive test coverage

## 🎨 Design System

### Color Palette
- **Primary**: Modern blue (#6750A4)
- **Secondary**: Complementary purple
- **Tertiary**: Accent green
- **Surface**: Clean whites and grays
- **Error/Success**: Semantic colors

### Components
- **Cards**: Elevated with rounded corners
- **Buttons**: Material 3 style with proper elevation
- **Navigation**: Bottom navigation bar
- **Typography**: Consistent text hierarchy
- **Icons**: Material Design icon set

## 🔄 Future Enhancements

### Planned Features
- **Real API Integration**: Replace mock data
- **Push Notifications**: News and price alerts
- **Biometric Security**: Fingerprint/Face ID
- **Multi-language Support**: Internationalization
- **Advanced Charts**: Price and portfolio graphs
- **QR Code Scanner**: For receiving payments
- **Transaction Signing**: Secure transaction handling

### Architecture Extensions
- **Repository Pattern**: Add data sources
- **Use Cases**: Implement business logic
- **Error Handling**: Comprehensive error states
- **Caching**: Local data persistence
- **Offline Support**: Network-independent features

## 📱 Platform Support

- **iOS**: Native iOS styling and behavior
- **Android**: Material Design 3 components
- **Web**: Responsive web layout
- **macOS**: Native macOS styling
- **Linux**: GTK-based styling
- **Windows**: Windows 11 styling

The Zentriq app now provides a solid foundation for building a comprehensive Algorand wallet with modern architecture, beautiful design, and scalable code structure.
