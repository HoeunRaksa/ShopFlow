import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/app_style.dart';

import '../../../home/presentation/state/favorite_controller.dart';
import '../widgets/favorite_empty_state.dart';
import '../widgets/favorite_grid.dart';

class FavoriteView extends ConsumerWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);
        final bodySize = AppStyle.bodySize(context, w);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: favorites.isEmpty
              ? FavoriteEmptyState(bodySize: bodySize)
              : FavoriteList(
                  favorites: favorites,
                  padding: padding,
                ),
        );
      },
    );
  }
}