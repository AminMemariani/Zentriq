import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../../core/constants/app_enums.dart';

/// Custom bottom navigation bar with Material 3 design
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return NavigationBar(
          selectedIndex: viewModel.currentIndex,
          onDestinationSelected: (index) {
            viewModel.changePageByIndex(index);
          },
          destinations: AppPage.values.map((page) {
            return NavigationDestination(
              icon: FaIcon(_getIconData(page.iconName), size: 20),
              selectedIcon: FaIcon(_getIconData(page.iconName), size: 20),
              label: page.title,
            );
          }).toList(),
        );
      },
    );
  }

  /// Converts icon name string to FontAwesome IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return FontAwesomeIcons.wallet;
      case 'trending_up':
        return FontAwesomeIcons.chartLine;
      case 'apps':
        return FontAwesomeIcons.cubes;
      case 'newspaper':
        return FontAwesomeIcons.newspaper;
      case 'token':
        return FontAwesomeIcons.coins;
      case 'image':
        return FontAwesomeIcons.image;
      default:
        return FontAwesomeIcons.circle;
    }
  }
}
