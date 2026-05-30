import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/category/presentation/state/category_controller.dart';
import 'package:newprovider/shared/app_custom_appBar.dart';
import '../../../../core/utils/helper_image.dart';
import '../../../../shared/app_scaffold.dart';
import '../state/product_controller.dart';
import '../widgets/product_form.dart';

class ProductManagement extends ConsumerStatefulWidget {
  final int? productId;
  const ProductManagement({super.key, this.productId});

  @override
  ConsumerState<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends ConsumerState<ProductManagement> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  String? imageUrl;
  File? imageFile;
  int? selectedCategoryId;
  bool isInitialized = false;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    stockController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.productId != null;
    final height = AppStyle.appBarHeight(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        if (isEdit) {
          final productAsync = ref.watch(
            productDetailProvider(widget.productId!),
          );
          return productAsync.when(
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => const Scaffold(body: Center(child: Text("Error"))),
            data: (product) {
              if (!isInitialized) {
                nameController.text = product.name;
                descriptionController.text = product.description;
                priceController.text = product.price.toString();
                stockController.text = product.stock.toString();
                selectedCategoryId = product.categoryId;
                imageUrl = HelperImage.buildImageUrl(product.imageUrl);
                isInitialized = true;
              }
              return AppScaffold(
                appBar: AppCustomAppBar(
                  title: "Modify Product",
                  backgroundColor: theme.scaffoldBackgroundColor,
                  height: height,
                ),
                body: SingleChildScrollView(
                  child: _buildForm(isEdit, w),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: _buildForm(isEdit, w),
          ),
        );
      },
    );
  }

  Widget _buildForm(bool isEdit, double w) {
    final categoryAsync = ref.watch(categoryControllerProvider);
    final bodySize = AppStyle.bodySize(context, w);
    return ProductForm(
      isEdit: isEdit,
      productId: widget.productId,
      nameController: nameController,
      descriptionController: descriptionController,
      priceController: priceController,
      stockController: stockController,
      imageUrl: imageUrl,
      imageFile: imageFile,
      selectedCategoryId: selectedCategoryId,
      onImagePick: pickImage,
      onCategoryChanged: (value) => setState(() => selectedCategoryId = value),
      categoryItems: categoryAsync.when(
        data: (categories) => categories.map((c) {
          return DropdownMenuItem<int>(value: c.id, child: Text(c.name));
        }).toList(),
        loading: () => <DropdownMenuItem<int>>[],
        error: (e, _) => <DropdownMenuItem<int>>[],
      ),
      bodySize: bodySize,
    );
  }
}