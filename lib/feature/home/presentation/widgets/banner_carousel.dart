import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/core/utils/helper_image.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';


class BannerCarousel extends StatefulWidget {
  final List<ProductResponse> products;
  const BannerCarousel({super.key, required this.products});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.products.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final h = AppStyle.screenHeight(context);
    final  bannerSize = AppStyle.heightBanner(context,h);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: bannerSize,
        width: double.infinity,
        child: Stack(
          children: [
            // PAGE VIEW
            PageView.builder(
              controller: _pageController,
              itemCount: widget.products.length,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final banner = widget.products[index];
                final image = HelperImage.buildImageUrl(banner.imageUrl);
                return
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      // IMAGE
                      CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                      // DARK OVERLAY
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.55),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // CONTENT — use Positioned instead of Column
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // ✅ shrink to content only
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.description,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,                    // ✅ prevent unbounded text
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              banner.categoryName ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 14),
                            FilledButton(
                              onPressed: () {},
                              child: Text(banner.name),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
              },
            ),

            // DOT INDICATORS
            Positioned(
              bottom: 12,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.products.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}