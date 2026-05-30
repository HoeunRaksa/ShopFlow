import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';

class HomeDrawerHeader extends ConsumerWidget {
  final double padding;
  final double iconSize;
  final double bodySize;
  final double titleSize;

  const HomeDrawerHeader({
    super.key,
    required this.padding,
    required this.iconSize,
    required this.bodySize,
    required this.titleSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userControllerProvider);
    final theme = Theme.of(context);

    return userAsync.when(
      data: (user) {
        final String imageProvider = user?.displayImage ?? '';
        final fullName = user == null
            ? 'Guest'
            : '${user.firstName} ${user.lastName}';
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(.12),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(.7),
                      theme.colorScheme.secondary.withOpacity(.7),
                    ],
                  ),
                ),
                child: InkWell(
                    onTap: (){
                          context.push("/profile", extra: user);
                    },
                     child: CircleAvatar(
                       radius: 38,
                       backgroundColor: theme.colorScheme.surface,
                       child: ClipOval(
                         child: CachedNetworkImage(
                           imageUrl: imageProvider,
                           width: 72,
                           height: 72,
                           fit: BoxFit.cover,
                           placeholder: (_, __) => const SizedBox(
                             width: 22,
                             height: 22,
                             child: CircularProgressIndicator(strokeWidth: 2),
                           ),
                           errorWidget: (_, __, ___) => Icon(
                             Icons.person_rounded,
                             size: 36,
                             color: theme.colorScheme.primary,
                           ),
                         ),
                       ),
                     ),
                )
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: bodySize - 2,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        user?.role ?? "Free",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: bodySize - 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => const Text("Guest"),
    );
  }
}
