import 'package:flutter/material.dart';
import 'profile_row_tile.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.onChangePassword,
    required this.onNotifications,
    required this.onContact
  });

  final VoidCallback onChangePassword;
  final VoidCallback onNotifications;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileRowTile(
          icon: Icons.lock_outline_rounded,
          label: '',
          value: 'Change password',
          onTap: onChangePassword,
        ),
        ProfileRowTile(
          icon: Icons.contact_page_rounded,
          label: '',
          value: 'Create Contact',
          onTap: onContact,
        ),
        ProfileRowTile(
          icon: Icons.notifications_none_rounded,
          label: '',
          value: 'Notifications',
          onTap: onNotifications,
          isLast: true,
        ),
      ],
    );
  }
}