import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';
import '../../../../shared/app_image_picker.dart';
import '../../../../shared/app_select_field.dart';
import '../../../../shared/app_text_field.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController stockController;
  final String? imageUrl;
  final File? imageFile;
  final int? selectedCategoryId;
  final VoidCallback onImagePick;
  final ValueChanged<int?> onCategoryChanged;
  final List<DropdownMenuItem<int>> categoryItems;

  const ProductFormFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.stockController,
    required this.onImagePick,
    required this.onCategoryChanged,
    this.imageUrl,
    this.imageFile,
    this.selectedCategoryId,
    required this.categoryItems
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = AppStyle.bodySize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Name", style: TextStyle(fontSize: fontSize, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        AppTextField(controller: nameController, hint: "Enter product name",),
        const SizedBox(height: 16),
        Text("Description", style: TextStyle(fontSize: fontSize, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        AppTextField(controller: descriptionController,hint: "Enter description"),
        const SizedBox(height: 16),
        Text("Price", style: TextStyle(fontSize: fontSize, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        AppTextField(
          controller: priceController,
          hint: "Enter price",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        Text("Stock", style: TextStyle(fontSize: fontSize, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        AppTextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          hint: "Enter stock",
        ),
        const SizedBox(height: 20),
        AppImagePicker(
          label: "Product Image",
          file: imageFile,
          imageUrl: imageUrl,
          onTap: onImagePick,
        ),
        const SizedBox(height: 20),
        Text("Category", style: TextStyle(fontSize: fontSize, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        AppSelectField<int>(
          label: "Category",
          value: selectedCategoryId,
          items: categoryItems,
          onChanged: onCategoryChanged,
        ),
      ],
    );
  }
}