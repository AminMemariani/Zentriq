import 'package:flutter/material.dart';

/// Design system for consistent UI styling across the app
class DesignSystem {
  // Private constructor to prevent instantiation
  DesignSystem._();

  // Card styling
  static const double cardRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double cardPadding = 20.0;
  static const double cardSpacing = 16.0;

  // Spacing system
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXL = 32.0;
  static const double iconSizeXXL = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Creates a consistent card with rounded corners and subtle shadow
  static Card createCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: elevation ?? cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      color: color,
      margin: margin ?? const EdgeInsets.all(cardSpacing),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(cardPadding),
          child: child,
        ),
      ),
    );
  }

  /// Creates a compact card for smaller content
  static Card createCompactCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: elevation ?? cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      color: color,
      margin:
          margin ??
          const EdgeInsets.symmetric(
            horizontal: cardSpacing,
            vertical: spacingS,
          ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radiusM),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(spacingM),
          child: child,
        ),
      ),
    );
  }

  /// Creates a section header with consistent styling
  static Widget createSectionHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: cardSpacing,
        vertical: spacingS,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: spacingXS),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  /// Creates a stat card with icon, title, and value
  static Widget createStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Color? iconColor,
    Color? valueColor,
    bool isPositive = true,
  }) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveValueColor =
        valueColor ??
        (isPositive ? theme.colorScheme.primary : theme.colorScheme.error);

    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: iconSizeL, color: effectiveIconColor),
            const SizedBox(height: spacingM),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingXS),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveValueColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: spacingXS),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Creates a list tile with consistent styling
  static Widget createListTile(
    BuildContext context, {
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: cardSpacing,
        vertical: spacingXS,
      ),
      child: ListTile(
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: spacingM,
              vertical: spacingS,
            ),
        leading: leading,
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
    );
  }

  /// Creates a chip with consistent styling
  static Widget createChip(
    BuildContext context, {
    required String label,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        (isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest);
    final effectiveTextColor =
        textColor ??
        (isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant);

    return FilterChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: iconSizeS) : null,
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap() : null,
      backgroundColor: effectiveBackgroundColor,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(color: effectiveTextColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
    );
  }

  /// Creates a button with consistent styling
  static Widget createButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isPrimary = true,
    bool isOutlined = false,
    bool isLoading = false,
    double? width,
  }) {
    final theme = Theme.of(context);

    Widget buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSizeM),
                const SizedBox(width: spacingS),
              ],
              Text(text),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: spacingL,
              vertical: spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
            ),
          ),
          child: buttonChild,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
        ),
        child: buttonChild,
      ),
    );
  }

  /// Creates a search field with consistent styling
  static Widget createSearchField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    VoidCallback? onClear,
    ValueChanged<String>? onChanged,
  }) {
    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
      margin: const EdgeInsets.all(cardSpacing),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingM,
          ),
        ),
      ),
    );
  }

  /// Creates a loading indicator with consistent styling
  static Widget createLoadingIndicator(
    BuildContext context, {
    String? message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: spacingM),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates an error widget with consistent styling
  static Widget createErrorWidget(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(cardSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: iconSizeXXL,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: spacingM),
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: spacingS),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: spacingL),
              createButton(
                context,
                text: 'Try Again',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Creates a responsive grid with consistent spacing
  static Widget createResponsiveGrid({
    required List<Widget> children,
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
    double spacing = cardSpacing,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = mobileColumns;
        if (constraints.maxWidth > 1200) {
          columns = desktopColumns;
        } else if (constraints.maxWidth > 600) {
          columns = tabletColumns;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.2,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  /// Creates a responsive list with consistent spacing
  static Widget createResponsiveList({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(cardSpacing),
      itemCount: children.length,
      separatorBuilder: (context, index) => const SizedBox(height: spacingM),
      itemBuilder: (context, index) => children[index],
    );
  }
}
