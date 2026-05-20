import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/product/presentation/widgets/product_form_fields.dart';
import '../../../../shared/app_button.dart.dart';
import '../../data/models/product_request.dart';
import '../state/product_controller.dart';

class ProductForm extends ConsumerWidget {
  final bool isEdit;
  final int? productId;
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
  final double bodySize;

  const ProductForm({
    super.key,
    required this.isEdit,
    required this.productId,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.stockController,
    required this.onImagePick,
    required this.onCategoryChanged,
    required this.categoryItems,
    this.imageUrl,
    this.imageFile,
    this.selectedCategoryId,
    required this.bodySize,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productControllerProvider);
    final maxSized = AppStyle.maxWidth(context);
    final padding = AppStyle.padding(context);
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxSized),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: padding),

      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEdit) const SizedBox(height: 24),
            _SectionHeader(
              label: isEdit ? 'Edit Product' : 'New Product',
              icon: isEdit ? Icons.edit_outlined : Icons.add_box_outlined,
            ),
            const SizedBox(height: 16),
             ProductFormFields(
                nameController: nameController,
                descriptionController: descriptionController,
                priceController: priceController,
                stockController: stockController,
                imageUrl: imageUrl,
                imageFile: imageFile,
                selectedCategoryId: selectedCategoryId,
                onImagePick: onImagePick,
                onCategoryChanged: onCategoryChanged,
                categoryItems: categoryItems,
              ),

            const SizedBox(height: 24),
            AppButton(
              isFullWidth: true,
              label: productState.isLoading
                  ? 'Saving…'
                  : isEdit
                  ? 'Update'
                  : 'Save',
              onPressed: productState.isLoading
                  ? null
                  : () => _onSubmit(context, ref),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
        ),);
  }

  Future<void> _onSubmit(BuildContext context, WidgetRef ref) async {
    if (!isEdit && imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select image')));
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select category')));
      return;
    }

    final request = ProductRequest(
      name: nameController.text,
      price: double.parse(priceController.text),
      description: descriptionController.text,
      stock: int.parse(stockController.text),
      categoryId: selectedCategoryId,
      isActive: true,
    );

    final controller = ref.read(productControllerProvider.notifier);

    if (isEdit) {
      await controller.updateProduct(
        productId!,
        request: request,
        imageFile: imageFile!,
      );
    } else {
      await controller.createProduct(request: request, imageFile: imageFile!);
    }

    final result = ref.read(productControllerProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.error.toString())));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Product updated successfully'
                : 'Product created successfully',
          ),
        ),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}


