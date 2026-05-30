import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newprovider/feature/history/data/models/order_history_response.dart';
import 'package:newprovider/feature/history/data/models/order_item_response.dart';
import '../core/app_style.dart';
import '../feature/product/data/models/product_response.dart';

class ProductHorizontalCard extends StatelessWidget {
  final OrderHistoryResponse? orderHistoryResponse;
  final OrderItemResponse? orderItemResponse;
  final ProductResponse product;
  final String imageUrl;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? bottomTrailing;
  final bool showStock;
  final bool showQty;

  const ProductHorizontalCard({
    super.key,
    required this.product,
    required this.imageUrl,
    this.orderItemResponse,
    this.orderHistoryResponse,
    this.onTap,
    this.trailing,
    this.bottomTrailing,
    this.showStock = true,
    this.showQty = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final width = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context);
    final radius = AppStyle.cardRadius(context);
    final baseSize = AppStyle.imageSize(context, width);
    final imageSize = baseSize;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? Colors.black.withOpacity(0.04)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding:  EdgeInsets.all(padding * 0.3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius * 0.8),
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: theme.colorScheme.primary,
                          size: AppStyle.iconSize(context),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: padding),

                Expanded(
                  child: SizedBox(
                    height: imageSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child:  Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppStyle.bodySize(context),
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            ?trailing,
                          ],
                        ),

                        SizedBox(height: AppStyle.sectionGap(context) * 0.5),



                        SizedBox(height: AppStyle.sectionGap(context) * 0.4),

                        Expanded(
                          child: Text(
                            product.description ?? "No description",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppStyle.bodySizeSmall(context),
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),

                        SizedBox(height: AppStyle.sectionGap(context) * 0.6),

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: padding * 0.7,
                                vertical: padding * 0.3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Text(
                                "\$${product.price}",
                                style: TextStyle(
                                  fontSize: AppStyle.bodySizeSmall(context),
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),

                            const Spacer(),

                            if (bottomTrailing != null)
                              bottomTrailing!
                            else if (showStock)
                              Text(
                                "Stock: ${product.stock ?? 0}",
                                style: TextStyle(
                                  fontSize: AppStyle.captionSize(context),
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            if (showQty)
                              Text(
                                "Quantity: ${orderItemResponse!.quantity}",
                                style: TextStyle(
                                  fontSize: AppStyle.bodySizeSmall(context),
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}