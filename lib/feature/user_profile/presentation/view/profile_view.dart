import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/shared/app_button.dart.dart';
import '../../../../core/app_style.dart';
import '../../data/model/UserResponse.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_settings_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required UserResponse user}) : _user = user;

  final UserResponse _user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void onChangePassword(){
        context.push("/passwordChanges");
    }
    void onContact(){
      context.push("/create-contact");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppStyle.profileMaxWidth(context, w),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppStyle.profileTopSpace(context, w)),
                          Center(child: ProfileAvatar(user: _user)),
                          SizedBox(
                            height: AppStyle.profileAvatarBottomSpace(context, w),
                          ),
                          _SectionLabel(label: 'Personal info', width: w),
                          SizedBox(height: AppStyle.profileSectionGap(context, w)),
                          _FieldCard(
                              width: w, child: ProfileInfoCard(user: _user)),
                          SizedBox(height: AppStyle.profileCardGap(context, w)),
                          _SectionLabel(label: 'Settings', width: w),
                          SizedBox(height: AppStyle.profileSectionGap(context, w)),
                          _FieldCard(
                            width: w,
                            child: ProfileSettingsCard(
                              onChangePassword: onChangePassword,
                              onNotifications: () {},
                              onContact: onContact,
                            ),
                          ),
                          SizedBox(height: AppStyle.profileCardGap(context, w)),
                          AppButton(
                            label: 'Sign out',
                            isFullWidth: true,
                            style: AppButtonStyle.danger,
                            onPressed: () {},
                            suffixIcon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: AppStyle.profileBottomSpace(context, w)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Private helpers ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.width});

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: AppStyle.profileSectionLabelSize(context, width),
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.child, required this.width});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppStyle.cardRadius(context, width)),
        border: Border.all(color: const Color(0xFFEAECF0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
