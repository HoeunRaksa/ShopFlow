import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/search/presentation/widgets/search_body.dart';
import 'package:newprovider/feature/search/presentation/widgets/search_field.dart';
import '../state/search_controller.dart';
import '../state/search_result_controller.dart';

class RelatedHomeSearch extends ConsumerWidget {
  const RelatedHomeSearch({super.key, required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final iconSize = AppStyle.iconSize(context, w);
    final asyncHistory = ref.watch(searchControllerProvider);
    final searchText = ref.watch(searchTextProvider).toLowerCase();
    final isSubmit = ref.watch(isSubmitControllerProvider);

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: SearchBarDelegate(ref: ref, onDismiss: onDismiss),
        ),

        if (!isSubmit)
          asyncHistory.when(
            data: (histories) {
              final filterHistory = searchText.toLowerCase().isEmpty
                  ? histories
                  : histories
                  .where(
                    (item) =>
                    item.keyword.toLowerCase().startsWith(searchText),
              )
                  .toList();

              if (filterHistory.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No search history found'),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final history = filterHistory[index];

                    return Material(
                      child: InkWell(
                        onTap: () {
                          //Navigator.pop(context);
                        },
                        child: ListTile(
                          leading: const Icon(Icons.circle, size: 8),
                          title: Text(history.keyword),
                          trailing: IconButton(
                            icon: Icon(Icons.close, size: iconSize),
                            onPressed: () {
                              ref
                                  .read(searchControllerProvider.notifier)
                                  .removeItem(history.keyword);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: filterHistory.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(e.toString()),
              ),
            ),
          ),

        if (isSubmit)
          SliverFillRemaining(
            hasScrollBody: true,
            child: SearchBody(searchKey: searchText),
          ),
      ],
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  SearchBarDelegate({required this.ref, required this.onDismiss});

  final WidgetRef ref;
  final VoidCallback onDismiss;

  static final _controller = TextEditingController();
  static final _focusNode = FocusNode();

  static const _height = 66.00;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).scaffoldBackgroundColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SearchField(
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: (value) {
            final trimmed = value.trim();

            if (trimmed.isEmpty) return;

            ref.read(searchControllerProvider.notifier).saveSearch(trimmed);

            ref.read(isSubmitControllerProvider.notifier).state =
                trimmed.trim().isNotEmpty;

            ref.read(searchResultControllerProvider.notifier).performSearch(
              name: value,
              categoryName: value,
            );

            _focusNode.unfocus();
          },
          onClear: () {
            _controller.clear();
            _focusNode.requestFocus();

            ref.read(isSubmitControllerProvider.notifier).state = false;
            ref.read(searchTextProvider.notifier).state = '';
          },
          onDismiss: () {
            _controller.clear();
            _focusNode.unfocus();
            onDismiss();
          },
          onChange: (values) {
            ref.read(searchTextProvider.notifier).state = values.trim();
            ref.read(isSubmitControllerProvider.notifier).state = false;
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SearchBarDelegate old) => false;
}