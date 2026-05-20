import 'package:flutter/material.dart';
import '../../data/model/UserResponse.dart';
import 'profile_row_tile.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ProfileRowTile(
          icon: Icons.person_outline_rounded,
          label: 'First name',
          value: user.firstName,
        ),
        ProfileRowTile(
          icon: Icons.person_outline_rounded,
          label: 'Last name',
          value: user.lastName,
        ),
        ProfileRowTile(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: user.email,
        ),

        if(user.facebookLink != null)
        ProfileRowTile(
          icon: Icons.facebook_rounded,
          label: 'Facebook',
          value: user.facebookLink!,
        ),
        if(user.telegramLink != null)
        ProfileRowTile(
          icon: Icons.telegram_rounded,
          label: 'Telegram',
          value: user.telegramLink!,
        ),
        if(user.phoneNumber != null)
        ProfileRowTile(
          icon: Icons.call_rounded,
          label: 'Phone Number',
          value: user.phoneNumber!,
        ),

        ProfileRowTile(
          icon: Icons.verified_outlined,
          label: 'Status',
          value: 'Active',
          isLast: true,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Text(
              'Active',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}