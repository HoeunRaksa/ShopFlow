import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/UserResponse.dart';
import 'profile_row_tile.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.user});

  final UserResponse user;

  Future<void> _launchUrl(BuildContext context, String rawUrl) async {
    String urlString = rawUrl.trim();

    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }

    final uri = Uri.tryParse(urlString);
    if (uri == null) {
      _showError(context, 'Invalid link.');
      return;
    }

    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError(context, 'Could not open link.');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

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

        if (user.facebookLink != null)
          ProfileRowTile(
            icon: Icons.facebook_rounded,
            label: 'Facebook',
            value: '${user.firstName} ${user.lastName}',
            onTap: () => _launchUrl(context, user.facebookLink!),
            trailing: Icon(
              Icons.open_in_new_rounded,
              size: 15,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),

        if (user.telegramLink != null)
          ProfileRowTile(
            icon: Icons.telegram_rounded,
            label: 'Telegram',
            value: '${user.phoneNumber}',
            onTap: () => _launchUrl(context, user.telegramLink!),
            trailing: Icon(
              Icons.open_in_new_rounded,
              size: 15,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),

        if (user.phoneNumber != null)
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
              color: theme.colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
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