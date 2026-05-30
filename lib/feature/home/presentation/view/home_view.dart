import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/presentation/state/product_controller.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_scaffold.dart';
import '../../../search/presentation/widgets/related_home_search.dart';
import '../state/home_controller.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_body.dart';
import '../widgets/home_drawer.dart';

class HomeView extends ConsumerStatefulWidget {
  final Widget? body;

  const HomeView({super.key, this.body});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  final ScrollController _scrollController = ScrollController();

  bool _showFab = false;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 240;

      if (shouldShow != _showFab) {
        setState(() => _showFab = shouldShow);

        shouldShow ? _fabController.forward() : _fabController.reverse();
      }

      final position = _scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 300) {
        ref.read(productControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = AppStyle.screenWidth(context);
        final iconSize = AppStyle.iconSize(context, w * 2);
        final padding = AppStyle.padding(context, w);
        final titleSize = AppStyle.titleSize(context, w);
        final bodySize = AppStyle.bodySize(context, w);
        final scheme = Theme.of(context).colorScheme;
        final shellBody = ref.watch(shellBodyProvider);
        final isSearch = ref.watch(searchShowingProvider);
        final height = AppStyle.appBarHeight(context);
        return AppScaffold(
          appBar: (!isSearch)
              ? HomeAppBar(
                  title: ref.watch(appBarTitleProvider),
                  iconSize: iconSize * 1.3,
                  titleSize: titleSize,
                  height: height,
                  bodySize: bodySize,
                  onSearch: () {
                    ref.read(searchShowingProvider.notifier).state = true;
                  },
                  onNotification: () {},
                )
              : null,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBody: true,
          drawer: HomeDrawer(
            padding: padding,
            iconSize: iconSize,
            bodySize: bodySize,
            titleSize: titleSize,
          ),
          floatingActionButton: ScaleTransition(
            scale: CurvedAnimation(
              parent: _fabController,
              curve: Curves.easeOutBack,
            ),

            child: FloatingActionButton.extended(
              backgroundColor: scheme.primary,

              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              },

              icon: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Theme.of(context).colorScheme.surface,
              ),

              label: Text(
                "Top",
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),

          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: shellBody == null
                        ? HomeBody(scrollController: _scrollController)
                        : shellBody(),
                  ),
                ],
              ),

              if (isSearch)
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              if (isSearch)
                SafeArea(
                  child: RelatedHomeSearch(
                    onDismiss: () {
                      ref.read(searchShowingProvider.notifier).state = false;
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
