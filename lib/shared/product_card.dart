import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_style.dart';
import '../feature/product/data/models/product_response.dart';

class ProductCard extends StatelessWidget {
  final ProductResponse product;
  final String imageUrl;
  final bool isFav;
  final VoidCallback? setFav;

  const ProductCard({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.isFav,
    this.setFav,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final pad = cardWidth * 0.04;
        final fontSize = cardWidth * 0.07;
        final smallFont = cardWidth * 0.06;
        final iconSize = cardWidth * 0.09;
        final radius = cardWidth * 0.06;

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.brightness == Brightness.light
                      ? Colors.black.withOpacity(0.04)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [

                // ── IMAGE ───────────────────────────────
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color:
                            theme.colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color:
                            theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: theme.colorScheme.primary,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: pad,
                        left: pad,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: pad,
                            vertical: pad * 0.4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withOpacity(0.9),
                            borderRadius: BorderRadius.circular(
                              radius * 0.5,
                            ),
                          ),
                          child: Text(
                            "\$${product.price}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: smallFont,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CONTENT ─────────────────────────────
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(pad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (product.categoryName ?? "General")
                              .toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: smallFont,
                          ),
                        ),

                        SizedBox(height: pad * 0.3),

                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),

                        if (!AppStyle.isCompact(context)) ...[
                          SizedBox(height: pad * 0.3),

                          Expanded(
                            child: Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: smallFont,
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: pad * 0.4),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Stock: ${product.stock}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: smallFont,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),

                            SizedBox(width: pad * 0.5),

                            GestureDetector(
                              onTap: setFav,
                              child: Container(
                                padding: EdgeInsets.all(pad * 0.5),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    radius * 0.5,
                                  ),
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: iconSize,
                                  color: isFav
                                      ? Colors.pink
                                      : theme.colorScheme.primary,
                                ),
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
        );
      },
    );
  }
}