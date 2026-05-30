import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/user_profile/data/model/UserResponse.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/app_style.dart';
import 'block_social.dart';
import 'info_block.dart';
import 'other_content.dart';
import 'owner_row_title.dart';

class OwnerProfileBody extends ConsumerWidget {
  final UserResponse user;
  const OwnerProfileBody({super.key, required this.user});

  Future<void> _openUrl(String? url) async {
    if (url == null || url.trim().isEmpty) return;

    final uri = Uri.parse(url.trim());

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final w = AppStyle.screenWidth(context);
    final bottomSpace = AppStyle.bottomSpace(context, w);
    final double imageSize = w * 0.30;
    final image = CachedNetworkImageProvider(
      user.displayImage,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
              child: CircleAvatar(backgroundImage: image),
            ),
          ),
        ),
        SizedBox(height: bottomSpace),
        InfoBlock(
          title: 'Personal Info',
          children: [
            OwnerRowTitle(
              icon: Icons.person,
              text: '${user.firstName} ${user.lastName}',
              isReadOnly: true,
            ),
            OwnerRowTitle(
              icon: Icons.email,
              text: user.email,
              isReadOnly: true,
            ),
          ],
        ),
        SizedBox(height: bottomSpace),
        BlockSocial(
          children: [
            OwnerRowTitle(icon: Icons.facebook_rounded, text: "Facebook",
              onTap:() async {
                   await _openUrl(user.facebookLink);
              },
            ),
            OwnerRowTitle(icon: Icons.telegram_rounded, text: "Telegram"),
            OwnerRowTitle(
              icon: Icons.phone,
              text: user.phoneNumber ?? "None",
              color: Colors.green,
              onTap: () async{
                   await _openUrl(user.telegramLink);
              },
            ),
          ],
        ),
        SizedBox(height: bottomSpace),
        OtherContent(
          children: [
            OwnerRowTitle(
              icon: Icons.production_quantity_limits,
              text: "Share and content",
              color: theme.colorScheme.primary,
              onTap: () =>
                context.push('/owner-content', extra: user)
            ),
          ],
        ),
      ],
    );
  }
}
