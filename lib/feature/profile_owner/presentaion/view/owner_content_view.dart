import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/user_profile/data/model/UserResponse.dart';
import '../state/user_owner_controller.dart';
import '../widgets/owner_content_body.dart';
class OwnerContentView extends ConsumerStatefulWidget {
  final UserResponse user;
  const OwnerContentView({super.key, required this.user});
  @override
  ConsumerState<OwnerContentView> createState() => _OwnerContentViewState();
}

class _OwnerContentViewState extends ConsumerState<OwnerContentView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = AppStyle.screenHeight(context) * 0.06;
    final counter = ref.read(ownerCounterProductControllerProvider.notifier).state;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: w,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 52,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),

        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.surfaceVariant,
              backgroundImage: CachedNetworkImageProvider(
                widget.user.displayImage
              ),
            ),

            const SizedBox(width: 12),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ widget.user.firstName} ${ widget.user.lastName}" ,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "Owner • $counter ${counter > 1 ? "products" : "product"}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 26,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(child: OwnerContentBody(userId: widget.user.id)),
    );
  }
}
