import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/cart/presentation/state/cart_contoller.dart';

class ProductAddCartCounter extends ConsumerStatefulWidget {
  final double iconSize;
  final double textSize;
  final int min;
  final int max;
  final int productId;

  const ProductAddCartCounter({
    super.key,
    required this.iconSize,
    required this.textSize,
    required this.productId,
    this.min = 1,
    this.max = 99,
  });

  @override
  ConsumerState<ProductAddCartCounter> createState() =>
      _ProductAddCartCounterState();
}

class _ProductAddCartCounterState extends ConsumerState<ProductAddCartCounter>
    with SingleTickerProviderStateMixin {
  bool _minusTapped = false;
  bool _plusTapped = false;

  void _animateTap(bool isMinus) async {
    setState(() => isMinus ? _minusTapped = true : _plusTapped = true);

    await Future.delayed(const Duration(milliseconds: 140));

    if (mounted) {
      setState(() => isMinus ? _minusTapped = false : _plusTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = ref.watch(addCartQuantityProvider(widget.productId));
    final provider = ref.read(
      addCartQuantityProvider(widget.productId).notifier,
    );
    final isAtMin = quantity <= widget.min;
    final isAtMax = quantity >= widget.max;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ───────────────── Counter ─────────────────
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ───────────────── Minus ─────────────────
              _CounterButton(
                onTap: isAtMin
                    ? null
                    : () {
                        _animateTap(true);
                        if (provider.state > widget.min) {
                          provider.state--;
                        }
                      },
                tapped: _minusTapped,
                icon: Icons.remove_rounded,
                iconSize: widget.iconSize,
                isLeft: true,
                disabled: isAtMin,
                theme: theme,
              ),

              // ───────────────── Quantity ─────────────────
              Container(
                width: 56,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    quantity.toString(),
                    key: ValueKey(quantity),
                    style: TextStyle(
                      fontSize: widget.textSize,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // ───────────────── Plus ─────────────────
              _CounterButton(
                onTap: isAtMax
                    ? null
                    : () {
                        _animateTap(false);
                        if (provider.state < widget.max) {
                          provider.state++;
                        }
                      },
                tapped: _plusTapped,
                icon: Icons.add_rounded,
                iconSize: widget.iconSize,
                isLeft: false,
                disabled: isAtMax,
                theme: theme,
              ),
            ],
          ),
        ),

        // ───────────────── Hint ─────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: (isAtMin || isAtMax)
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAtMax
                            ? Icons.info_outline_rounded
                            : Icons.do_not_disturb_on_outlined,
                        size: 12,
                        color: isAtMax
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAtMax
                            ? "Max ${widget.max} items"
                            : "Min ${widget.min} item",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isAtMax
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool tapped;
  final IconData icon;
  final double iconSize;
  final bool isLeft;
  final bool disabled;
  final ThemeData theme;

  const _CounterButton({
    required this.onTap,
    required this.tapped,
    required this.icon,
    required this.iconSize,
    required this.isLeft,
    required this.disabled,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: tapped
              ? theme.colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(13) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(13),
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: disabled
              ? theme.colorScheme.onSurface.withOpacity(0.2)
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
