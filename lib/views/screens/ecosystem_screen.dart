import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/ecosystem_viewmodel.dart';
import '../../domain/entities/project.dart';
import '../widgets/base_screen.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

/// Ecosystem screen for Algorand projects and dApps with MVVM pattern
class EcosystemScreen extends StatefulWidget {
  const EcosystemScreen({super.key});

  @override
  State<EcosystemScreen> createState() => _EcosystemScreenState();
}

class _EcosystemScreenState extends State<EcosystemScreen> {
  String _selectedView = 'Grid';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load project data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EcosystemViewModel>().loadAllProjects();
      context.read<EcosystemViewModel>().loadFeaturedProjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Ecosystem',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<EcosystemViewModel>().refreshProjects();
          },
        ),
      ],
      body: Consumer<EcosystemViewModel>(
        builder: (context, viewModel, child) {
          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, viewModel),
            tablet: _buildTabletLayout(context, viewModel),
            desktop: _buildDesktopLayout(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    return Column(
      children: [
        _buildEcosystemOverview(context, viewModel),
        _buildFiltersAndSearch(context, viewModel),
        _buildViewToggle(context),
        Expanded(child: _buildProjectsContent(context, viewModel)),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildEcosystemOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildFiltersAndSearch(context, viewModel),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildViewToggle(context),
              Expanded(child: _buildProjectsContent(context, viewModel)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildEcosystemOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildFiltersAndSearch(context, viewModel),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildViewToggle(context),
              Expanded(child: _buildProjectsContent(context, viewModel)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcosystemOverview(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    final stats = viewModel.getEcosystemStats();

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Algorand Ecosystem',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEcosystemStat(
                    context,
                    'Total Projects',
                    '${stats['totalProjects']}',
                    Icons.account_balance,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEcosystemStat(
                    context,
                    'Verified',
                    '${stats['verifiedProjects']}',
                    Icons.verified,
                    isPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildEcosystemStat(
                    context,
                    'Total TVL',
                    '\$${_formatLargeNumber(stats['totalTVL'] as double)}',
                    Icons.trending_up,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEcosystemStat(
                    context,
                    'Active Users',
                    _formatLargeNumber(
                      (stats['totalActiveUsers'] as int).toDouble(),
                    ),
                    Icons.people,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcosystemStat(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isPositive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        viewModel.setSearchQuery('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              viewModel.setSearchQuery(value);
            },
          ),
          const SizedBox(height: 12),
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(context, viewModel, null, 'All'),
                const SizedBox(width: 8),
                ...ProjectCategory.values.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip(
                      context,
                      viewModel,
                      category,
                      category.displayName,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    EcosystemViewModel viewModel,
    ProjectCategory? category,
    String label,
  ) {
    final isSelected = viewModel.selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        viewModel.setCategoryFilter(selected ? category : null);
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment<String>(
                value: 'Grid',
                icon: Icon(Icons.grid_view),
                label: Text('Grid'),
              ),
              ButtonSegment<String>(
                value: 'List',
                icon: Icon(Icons.list),
                label: Text('List'),
              ),
            ],
            selected: {_selectedView},
            onSelectionChanged: (Set<String> selection) {
              setState(() {
                _selectedView = selection.first;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsContent(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects & dApps',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildProjectsList(context, viewModel)),
        ],
      ),
    );
  }

  Widget _buildProjectsList(
    BuildContext context,
    EcosystemViewModel viewModel,
  ) {
    if (viewModel.isLoadingAllProjects && viewModel.allProjects.isEmpty) {
      return const LoadingWidget(message: 'Loading projects...');
    }

    if (viewModel.hasAllProjectsError && viewModel.allProjects.isEmpty) {
      return custom.ErrorWidget(
        message: viewModel.allProjectsErrorMessage!,
        onRetry: () => viewModel.loadAllProjects(),
      );
    }

    final filteredProjects = viewModel.getFilteredProjects();
    if (filteredProjects.isEmpty) {
      return _buildEmptyState(context);
    }

    if (_selectedView == 'Grid') {
      return _buildProjectsGrid(context, filteredProjects);
    } else {
      return _buildProjectsListView(context, filteredProjects);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(BuildContext context, List<Project> projects) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _buildProjectCard(context, project);
      },
    );
  }

  Widget _buildProjectsListView(BuildContext context, List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _buildProjectListItem(context, project);
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      child: InkWell(
        onTap: () => _showProjectDetails(context, project),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      project.name.substring(0, 1),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (project.isVerified)
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                project.name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                project.shortDescription,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      project.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (project.hasToken)
                    Icon(
                      Icons.token,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectListItem(BuildContext context, Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            project.name.substring(0, 1),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              project.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (project.isVerified)
              Icon(
                Icons.verified,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.shortDescription),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project.category.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (project.hasToken)
                  Icon(
                    Icons.token,
                    size: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              project.formattedTVL,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text('TVL', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        onTap: () => _showProjectDetails(context, project),
      ),
    );
  }

  void _showProjectDetails(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                project.name.substring(0, 1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(project.name),
                      if (project.isVerified) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    project.category.displayName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.description),
              const SizedBox(height: 16),
              _buildDetailRow('Website', project.website),
              _buildDetailRow('Launch Date', project.formattedLaunchDate),
              _buildDetailRow('Total Value Locked', project.formattedTVL),
              _buildDetailRow('Active Users', project.formattedActiveUsers),
              if (project.hasToken) ...[
                _buildDetailRow('Token Symbol', project.tokenSymbol!),
                _buildDetailRow('Token Price', project.formattedTokenPrice),
                _buildDetailRow('Market Cap', project.formattedMarketCap),
              ],
              if (project.socialLinks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Social Links',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...project.socialLinks.entries.map(
                  (entry) =>
                      _buildDetailRow(entry.key.toUpperCase(), entry.value),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Open project website
            },
            child: const Text('Visit Website'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}
