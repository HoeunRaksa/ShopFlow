import 'dart:io';
import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  const AppImagePicker({
    super.key,
    this.label,
    this.file,
    this.imageUrl,
    required this.onTap,
    this.errorText,
  });

  final String? label;
  final File? file;
  final String? imageUrl;
  final VoidCallback onTap;
  final String? errorText;

  static const _errorClr = Color(0xFFA32D2D);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _onSuface = theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
        ],

        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null ? _errorClr : Colors.grey.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildImage(context),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(fontSize: 11, color: _errorClr),
          ),
        ],
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme;
    if (file != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          file!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) {
            return Center(child: Text("Image failed to load", style: TextStyle(color: Theme.of(context).colorScheme.onSurface),));
          },
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_rounded, size: 40, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(height: 8),
        const Text("Tap to select image"),
      ],
    );
  }
}