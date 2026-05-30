import 'package:flutter/material.dart';
import 'package:newprovider/feature/product/presentation/widgets/product_addCart_counter.dart';
import 'package:newprovider/feature/product/presentation/widgets/product_detail_image.dart';
import '../../../../shared/app_button.dart.dart';

class ProductDetailBody extends StatelessWidget {
  final dynamic product;
  final double maxWidth;
  final double titleSize;
  final double bodySize;
  final ThemeData theme;
  final double iconSize;
  final VoidCallback add;
  final VoidCallback onTop;
  final bool isFromHome;

  const ProductDetailBody({
    super.key,
    required this.product,
    required this.maxWidth,
    required this.titleSize,
    required this.bodySize,
    required this.theme,
    required this.iconSize,
    required this.add,
    required this.onTop,
    this.isFromHome = false
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Full bleed image ──
            ProductDetailImage(imageUrl: product.imageUrl, onTop: onTop, isOwner: isFromHome,),

           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.2), width: 1),
                    ),
                    child: Text(
                      product.categoryName!,
                      style: TextStyle(
                        fontSize: bodySize - 1,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSecondaryContainer,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Product name ──
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Price row ──
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: 24,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      // ── Star rating placeholder ──
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < 4
                                ? Icons.star_rounded
                                : Icons.star_half_rounded,
                            size: 16,
                            color: Colors.amber.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "4.2",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Divider ──
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),

                  const SizedBox(height: 20),

                  // ── Description ──
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description ?? "No description available.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.65,
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Divider ──
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),

                  const SizedBox(height: 20),

                  // ── Quantity row ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quantity",
                            style: TextStyle(
                              fontSize: bodySize,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Select how many",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ProductAddCartCounter(
                        iconSize: iconSize,
                        textSize: bodySize,
                        productId: product.id,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Add to Cart button ──
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: "Add to Cart",
                      isFullWidth: true,
                      prefixIcon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                      ),
                      onPressed: add,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),

          ],
        ),
      ),
    );
  }
}
