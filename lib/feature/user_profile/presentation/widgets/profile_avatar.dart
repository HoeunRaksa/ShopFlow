import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import 'package:newprovider/shared/app_button.dart.dart';
import '../../data/model/UserResponse.dart';

class ProfileAvatar extends ConsumerStatefulWidget {
  final UserResponse user;
  const ProfileAvatar({super.key, required this.user});
  @override
  ConsumerState<ProfileAvatar> createState() => _ProfileAvatar();
}

class _ProfileAvatar extends ConsumerState<ProfileAvatar> {
  late final user = widget.user;
  File? imageFile;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
      await showConfirmDialog();
    }
  }

  Future<void> showConfirmDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Do you want to change profile image?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  imageFile = null;
                });
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            AppButton(
              isRounded: true,
              label: "Accept",
              onPressed: (){
                if(imageFile != null){
                   ref.read(userControllerProvider.notifier).uploadImage(imageFile!);
                   if (!context.mounted) return;
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text("Profile updated"),
                     ),
                   );
                   Navigator.pop(context, true);
                   return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please chose an image"),
                  ),
                );
              },
              style: AppButtonStyle.warning,
            )
          ],
        );
      },
    );

    if (result != true) {
      setState(() {
        imageFile = null;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final image = imageFile != null
        ? FileImage(imageFile!) as ImageProvider
        : CachedNetworkImageProvider(user.displayImage);
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: pickImage,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface, width: 3),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Name ───────────────────────────────────────────────
        Text(
          user.lastName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        // ── Email ──────────────────────────────────────────────
        Text(
          user.email,
          style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
