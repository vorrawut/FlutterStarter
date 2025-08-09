import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/business_card.dart';
import '../controllers/business_cards_controller.dart';
import 'business_card_widget.dart';
import 'loading_widget.dart';
import 'error_widget.dart';

/// Business cards tab widget that displays business cards with filtering
/// Demonstrates clean separation between UI and business logic
class BusinessCardsTab extends StatefulWidget {
  const BusinessCardsTab({super.key});

  @override
  State<BusinessCardsTab> createState() => _BusinessCardsTabState();
}

class _BusinessCardsTabState extends State<BusinessCardsTab>
    with ResponsiveMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessCardsController>(
      builder: (context, controller, child) {
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            slivers: [
              _buildHeader(),
              _buildSearchAndFilters(controller),
              _buildContent(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.businessCardsHeader,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: responsive(
                  mobile: 24.0,
                  tablet: 28.0,
                  desktop: 32.0,
                ),
              ),
            ),
            Spacing.verticalSm,
            Text(
              AppStrings.businessCardsSubheader,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(BusinessCardsController controller) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.responsiveVertical(context),
            _buildSearchBar(controller),
            Spacing.verticalLg,
            _buildStyleFilters(controller),
            if (controller.hasFiltersApplied) ...[
              Spacing.verticalMd,
              _buildActiveFilters(controller),
            ],
            Spacing.responsiveVertical(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BusinessCardsController controller) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search business cards...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  controller.updateSearchQuery('');
                  _searchFocusNode.unfocus();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      onChanged: controller.updateSearchQuery,
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildStyleFilters(BusinessCardsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Style',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.verticalMd,
        ResponsiveBuilder(
          mobile: _buildMobileFilters(controller),
          tablet: _buildDesktopFilters(controller),
          desktop: _buildDesktopFilters(controller),
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BusinessCardsController controller) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: BusinessCardStyle.values.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilterChip(
              label: 'All',
              isSelected: controller.selectedStyle == null,
              count: controller.totalCardsCount,
              onTap: () => controller.filterByStyle(null),
            );
          }

          final style = BusinessCardStyle.values[index - 1];
          final count = controller.cardCountByStyle[style] ?? 0;

          return _buildFilterChip(
            label: style.displayName,
            isSelected: controller.selectedStyle == style,
            count: count,
            onTap: () => controller.filterByStyle(style),
          );
        },
      ),
    );
  }

  Widget _buildDesktopFilters(BusinessCardsController controller) {
    return Wrap(
      spacing: AppConstants.spaceMd,
      runSpacing: AppConstants.spaceMd,
      children: [
        _buildFilterChip(
          label: 'All',
          isSelected: controller.selectedStyle == null,
          count: controller.totalCardsCount,
          onTap: () => controller.filterByStyle(null),
        ),
        ...BusinessCardStyle.values.map((style) {
          final count = controller.cardCountByStyle[style] ?? 0;
          return _buildFilterChip(
            label: style.displayName,
            isSelected: controller.selectedStyle == style,
            count: count,
            onTap: () => controller.filterByStyle(style),
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required int count,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: AppConstants.spaceMd),
      child: FilterChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BusinessCardsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: controller.clearFilters,
              child: const Text('Clear All'),
            ),
          ],
        ),
        Spacing.verticalSm,
        Wrap(
          spacing: AppConstants.spaceSm,
          runSpacing: AppConstants.spaceSm,
          children: [
            if (controller.selectedStyle != null)
              _buildActiveFilterChip(
                'Style: ${controller.selectedStyle!.displayName}',
                () => controller.filterByStyle(null),
              ),
            if (controller.searchQuery.isNotEmpty)
              _buildActiveFilterChip(
                'Search: "${controller.searchQuery}"',
                () {
                  _searchController.clear();
                  controller.updateSearchQuery('');
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: 12,
      ),
    );
  }

  Widget _buildContent(BusinessCardsController controller) {
    if (controller.isLoading) {
      return const SliverToBoxAdapter(
        child: LoadingWidget(message: 'Loading business cards...'),
      );
    }

    if (controller.hasError) {
      return SliverToBoxAdapter(
        child: CustomErrorWidget(
          message: controller.errorMessage!,
          onRetry: controller.refresh,
        ),
      );
    }

    final cards = controller.filteredCards;

    if (cards.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(controller),
      );
    }

    return SliverPadding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridColumns(
            context,
            mobile: 1,
            tablet: 2,
            desktop: 2,
            largeDesktop: 3,
          ),
          childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
          mainAxisSpacing: AppConstants.spaceXl,
          crossAxisSpacing: AppConstants.spaceLg,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final card = cards[index];
            return BusinessCardWidget(
              businessCard: card,
              onTap: () => _showCardDetails(card),
            );
          },
          childCount: cards.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BusinessCardsController controller) {
    final hasFilters = controller.hasFiltersApplied;

    return Center(
      child: Padding(
        padding: AppPadding.all2xl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.business_center_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            Spacing.vertical2xl,
            Text(
              hasFilters 
                  ? 'No cards match your filters'
                  : 'No business cards available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.verticalMd,
            Text(
              hasFilters
                  ? 'Try adjusting your search or filter criteria'
                  : 'Business cards will appear here once loaded',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              Spacing.vertical2xl,
              ElevatedButton(
                onPressed: controller.clearFilters,
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCardDetails(BusinessCard card) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: AppPadding.all2xl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Business Card Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Spacing.verticalLg,
              BusinessCardWidget(
                businessCard: card,
                onTap: null, // Disable tap in dialog
              ),
              Spacing.verticalLg,
              Text(
                'Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.verticalMd,
              _buildDetailRow('Name', card.name),
              _buildDetailRow('Title', card.title),
              _buildDetailRow('Company', card.company),
              _buildDetailRow('Email', card.email),
              _buildDetailRow('Phone', card.phone),
              _buildDetailRow('Website', card.website),
              _buildDetailRow('Style', card.style.displayName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}