import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/app_style.dart';
import '../../../../shared/app_scaffold.dart';
import '../../../home/presentation/state/favorite_controller.dart';
import '../widgets/favorite_empty_state.dart';
import '../widgets/favorite_grid.dart';

class FavoriteView extends ConsumerWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final bodySize = AppStyle.bodySize(context, w);

        return AppScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          usePadding: false,
          body: favoriteState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),

            error: (error, stack) => Center(
              child: Text(
                'Something went wrong: $error',
              ),
            ),

            data: (favorites) {
              return favorites.isEmpty
                  ? FavoriteEmptyState(bodySize: bodySize)
                  : FavoriteList(
                favorites: favorites,
              );
            },
          ),
        );
      },
    );
  }
}