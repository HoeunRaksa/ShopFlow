import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(28),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    width: iconSize + 28,
                    height: iconSize + 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: iconSize + 44,
                    height: iconSize + 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: imageProvider,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                               Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: bodySize - 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize + 2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Premium Member",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: bodySize - 3,
                    fontWeight: FontWeight.w600,
                  ),
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
