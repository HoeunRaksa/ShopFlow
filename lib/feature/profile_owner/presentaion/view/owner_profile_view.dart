import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/shared/app_bar_icon_button.dart';

import '../state/user_owner_controller.dart';
import '../widgets/owner_profile_body.dart';

class OwnerProfileView extends ConsumerWidget {
  final int userId;
  const OwnerProfileView({super.key, required this.userId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userOwnerProvider(userId));
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyActions: true,
        leading: AppBarIconButton(
          isBackground: false,
          icon: Icons.arrow_back,
          iconSize: 20,
          onPressed: () {
            ref.read(ownerPushVerificationControllerProvider.notifier).state = true;
            context.pop();},
        ),
      ),
      body: SingleChildScrollView(
        child: userAsync.when(
          data: (user) {
           return OwnerProfileBody(user: user);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e,s) => Center(
              child: Text(e.toString()),
          ),
        ),
      ),
    );
  }
}
