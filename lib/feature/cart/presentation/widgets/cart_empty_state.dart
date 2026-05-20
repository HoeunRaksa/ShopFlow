import 'package:flutter/material.dart';
import '../../../../../shared/app_button.dart.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF185FA5).withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 52,
                color: Color(0xFF185FA5),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D1B2A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Looks like you haven't added\nanything to your cart yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: "Start Shopping",
              isRounded: true,
              prefixIcon: const Icon(
                Icons.storefront_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}