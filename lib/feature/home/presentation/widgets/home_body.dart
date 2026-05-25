import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/category/data/models/category_item.dart';
import 'package:newprovider/feature/category/presentation/state/category_controller.dart';
import 'package:newprovider/feature/product/presentation/state/product_controller.dart';
import '../../../../core/app_style.dart';
import 'banner_carousel.dart';
import 'home_empty_state.dart';
import 'home_error_state.dart';
import 'home_loading_state.dart';
import 'home_product_grid.dart';

class HomeBody extends ConsumerWidget {
  final ScrollController? scrollController;

  const HomeBody({super.key, this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    void onTap(String category) {
      ref.read(selectedCategoryProvider.notifier).state = category;
    }

    final listOfCategories = ref.watch(categoryNameControllerProvider);
    final productState = ref.watch(productControllerProvider);
    final products = ref.watch(
      filterProductByCategoryNameControllerProvider(selectedCategory),
    );
    final productTop3 = ref.watch(top3ProductControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final iconSize = AppStyle.iconSize(context, w);
        final bodySize = AppStyle.bodySize(context, w);
        final bottomSpace = AppStyle.bottomSpace(context, w);
        final padding = AppStyle.padding(context, w);

        return RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 2,
          displacement: 60,
          onRefresh: () =>
              ref.read(productControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              productTop3.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: HomeLoadingState(),
                ),
                error: (error, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: HomeErrorState(
                    error: error,
                    iconSize: iconSize,
                    onRetry: () {},
                  ),
                ),
                data: (product3) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(padding, 12, padding, 8),
                      child: BannerCarousel(products: product3),
                    ),
                  );
                },
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryStripDelegate(
                  selectCategory: selectedCategory,
                  onTap: onTap,
                  padding: padding,
                  height: 64,
                  categories: listOfCategories,
                ),
              ),

              productState.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: HomeLoadingState(),
                ),
                error: (error, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: HomeErrorState(
                    error: error,
                    iconSize: iconSize,
                    onRetry: () =>
                        ref.read(productControllerProvider.notifier).refresh(),
                  ),
                ),
                data: (_) {
                  if (products.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: HomeEmptyState(bodySize: bodySize),
                    );
                  }
                  return HomeProductGrid(
                    products: products,
                    constraints: constraints,
                  );
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: bottomSpace)),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryStripDelegate extends SliverPersistentHeaderDelegate {
  final double padding;
  final double height;
  final String selectCategory;
  final void Function(String) onTap;
  final List<CategoryItem> categories;

  _CategoryStripDelegate({
    required this.padding,
    required this.height,
    required this.selectCategory,
    required this.onTap,
    required this.categories,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: Platform.isIOS ? 0 : (overlapsContent ? 2 : 0),
      shadowColor: scheme.shadow.withOpacity(0.08),
      child: Container(
        decoration: BoxDecoration(
          border: Platform.isIOS && overlapsContent
              ? Border(
            bottom: BorderSide(
              color: scheme.outlineVariant.withOpacity(0.3),
              width: 0.5,
            ),
          )
              : null,
        ),
        child: SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 0),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _CategoryItem(
              category: categories[index],
              active: categories[index].name == selectCategory,
              onTap: () => onTap(categories[index].name),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryStripDelegate old) =>
      old.padding != padding ||
          old.height != height ||
          old.selectCategory != selectCategory ||
          old.categories != categories;
}

class _CategoryItem extends StatefulWidget {
  final CategoryItem category;
  final bool active;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.active,
    required this.onTap,
  });

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();

  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = widget.active;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? scheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? scheme.primary : scheme.onSurfaceVariant,
                    letterSpacing: 0.1,
                    height: 1.0,
                  ),
                  child: Text(
                    widget.category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}