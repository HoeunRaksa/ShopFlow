import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import 'package:newprovider/shared/app_bar_icon_button.dart';
import '../../../../core/app_size.dart';
import '../../../../core/app_style.dart';
import '../../data/model/user_set_contact.dart';
import '../widgets/create_contact_user.dart';

class CreateContactView extends ConsumerWidget {
  const CreateContactView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppStyle.padding(context);
    final titleSize = AppStyle.titleSize(context);
    final iconSize = AppStyle.iconSize(context);
    final userAsync = ref.watch(userControllerProvider);

    final maxWidth = AppSize.value(
      context,
      mobile: double.infinity,
      tablet: 500.0,
      desktop: 420.0,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: AppBarIconButton(
            icon: Icons.arrow_back_ios,
            iconSize: iconSize,
            onPressed: () => context.pop(),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: Text(
          'Create Contact',
          style: TextStyle(
            fontSize: titleSize,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.12),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: 24,
            ),
            child: userAsync.when(
                data: (user){
               final userSet = UserSetContact(facebookLink: user!.facebookLink,telegramLink: user.telegramLink, phoneNumber: user.phoneNumber);
                  return ContactForm( setContact: userSet,);
                },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
            )
          ),
        ),
      ),
    );
  }
}