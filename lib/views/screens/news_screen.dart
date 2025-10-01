import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../../domain/entities/news_article.dart';
import '../widgets/base_screen.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

/// News screen for crypto and Algorand news feed with MVVM pattern
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedTab = 'Latest';
  final List<String> _tabs = ['Latest', 'Trending', 'Breaking'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load news data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadLatestNews();
      context.read<NewsViewModel>().loadTrendingNews();
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
      title: 'News',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<NewsViewModel>().refreshNews();
          },
        ),
      ],
      body: Consumer<NewsViewModel>(
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

  Widget _buildMobileLayout(BuildContext context, NewsViewModel viewModel) {
    return Column(
      children: [
        _buildNewsOverview(context, viewModel),
        _buildTabBar(context),
        _buildSearchBar(context, viewModel),
        Expanded(child: _buildNewsContent(context, viewModel)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, NewsViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildNewsOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildSearchBar(context, viewModel),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildTabBar(context),
              Expanded(child: _buildNewsContent(context, viewModel)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, NewsViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildNewsOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildSearchBar(context, viewModel),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildTabBar(context),
              Expanded(child: _buildNewsContent(context, viewModel)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsOverview(BuildContext context, NewsViewModel viewModel) {
    final stats = viewModel.getNewsStats();

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'News Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildNewsStat(
                    context,
                    'Total Articles',
                    '${stats['totalArticles']}',
                    Icons.article,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNewsStat(
                    context,
                    'Breaking',
                    '${stats['breakingNews']}',
                    Icons.priority_high,
                    isBreaking: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNewsStat(
                    context,
                    'Trending',
                    '${stats['trendingArticles']}',
                    Icons.trending_up,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNewsStat(
                    context,
                    'Unread',
                    '${stats['unreadArticles']}',
                    Icons.mark_email_unread,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsStat(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isPositive = false,
    bool isBreaking = false,
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
          Icon(
            icon,
            size: 20,
            color: isBreaking
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isBreaking
                  ? Theme.of(context).colorScheme.error
                  : isPositive
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.map((tab) {
            final isSelected = _selectedTab == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(tab),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTab = tab;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                checkmarkColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, NewsViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search news...',
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
    );
  }

  Widget _buildNewsContent(BuildContext context, NewsViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getTabTitle(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Expanded(child: _buildNewsList(context, viewModel)),
        ],
      ),
    );
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case 'Trending':
        return 'Trending News';
      case 'Breaking':
        return 'Breaking News';
      default:
        return 'Latest News';
    }
  }

  Widget _buildNewsList(BuildContext context, NewsViewModel viewModel) {
    if (_isLoading(viewModel)) {
      return const LoadingWidget(message: 'Loading news...');
    }

    if (_hasError(viewModel)) {
      return custom.ErrorWidget(
        message: _getErrorMessage(viewModel),
        onRetry: () => _refreshData(viewModel),
      );
    }

    final articles = _getArticlesForTab(viewModel);
    if (articles.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildNewsCard(context, article);
      },
    );
  }

  bool _isLoading(NewsViewModel viewModel) {
    switch (_selectedTab) {
      case 'Trending':
        return viewModel.isLoadingTrendingNews;
      default:
        return viewModel.isLoadingLatestNews;
    }
  }

  bool _hasError(NewsViewModel viewModel) {
    switch (_selectedTab) {
      case 'Trending':
        return viewModel.hasTrendingNewsError;
      default:
        return viewModel.hasLatestNewsError;
    }
  }

  String _getErrorMessage(NewsViewModel viewModel) {
    switch (_selectedTab) {
      case 'Trending':
        return viewModel.trendingNewsErrorMessage ?? 'Unknown error';
      default:
        return viewModel.latestNewsErrorMessage ?? 'Unknown error';
    }
  }

  void _refreshData(NewsViewModel viewModel) {
    switch (_selectedTab) {
      case 'Trending':
        viewModel.loadTrendingNews();
        break;
      default:
        viewModel.loadLatestNews();
        break;
    }
  }

  List<NewsArticle> _getArticlesForTab(NewsViewModel viewModel) {
    switch (_selectedTab) {
      case 'Trending':
        return viewModel.trendingNews;
      case 'Breaking':
        return viewModel.getBreakingNews();
      default:
        return viewModel.getFilteredNews();
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
              Icons.article_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No news found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'News articles will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showNewsDetails(context, article),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: article.isBreakingNews
                          ? Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: article.isBreakingNews
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (article.isBreakingNews)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BREAKING',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                article.summary,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article.author,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article.formattedPublishedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (article.readTime != null)
                    Text(
                      article.formattedReadTime,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              if (article.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: article.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showNewsDetails(BuildContext context, NewsArticle article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article.category.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (article.isBreakingNews) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'BREAKING',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article.author,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article.formattedPublishedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                article.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              if (article.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Tags',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: article.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                          ),
                        ),
                      )
                      .toList(),
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
              // TODO: Open article URL
            },
            child: const Text('Read Full Article'),
          ),
        ],
      ),
    );
  }
}
