// home_view.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/presentation/state/product_controller.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_bar_icon_button.dart';
import '../../../../shared/app_text_field.dart';
import '../../../search/presentation/state/search_controller.dart';
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
    if(shouldShow != _showFab){
      setState(() => _showFab = shouldShow);
      shouldShow ?  _fabController.forward() : _fabController.reverse();
    }
    final position = _scrollController.position;
    if(position.pixels >= position.maxScrollExtent - 300){
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
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);
        final titleSize = AppStyle.titleSize(context, w);
        final bodySize = AppStyle.bodySize(context, w);
        final iconSize = AppStyle.iconSize(context, w);
        final scheme = Theme.of(context).colorScheme;
        final shellBody = ref.watch(shellBodyProvider);
        final isSearch = ref.watch(searchShowingProvider);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBody: true,
          drawer: HomeDrawer(
            padding: padding,
            iconSize: iconSize,
            bodySize: bodySize,
            titleSize: titleSize,
          ),

          // ── Pill FAB with label ─────────────────────────────
          floatingActionButton: ScaleTransition(
            scale: CurvedAnimation(
              parent: _fabController,
              curve: Curves.easeOutBack,
            ),
            child: FloatingActionButton.extended(
              backgroundColor: scheme.primary,
              elevation: 2,
              highlightElevation: 4,
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeOutCubic,
              ),
              icon: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: scheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Top',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          body: Stack(
            children: [
              Column(
                children: [
                  if (!isSearch)
                    HomeAppBar(
                      title: ref.watch(appBarTitleProvider),
                      padding: padding,
                      iconSize: iconSize,
                      titleSize: titleSize,
                      bodySize: bodySize,
                      onSearch: () {
                        ref.read(searchShowingProvider.notifier).state = !ref
                            .read(searchShowingProvider);
                      },
                      onNotification: () {},
                    ),
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              if (isSearch)
               SafeArea(
                child: RelatedHomeSearch(
                  onDismiss: () {
                    ref.read(searchShowingProvider.notifier).state = !ref
                        .read(searchShowingProvider);
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
