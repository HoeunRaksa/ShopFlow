import 'dart:async';
import 'package:flutter/material.dart';

class PaymentCountdownDialog extends StatefulWidget {
  final VoidCallback onDismissed;
  final int countdownSeconds;
  final Future<void> Function()? onConfirm;

  const PaymentCountdownDialog({
    super.key,
    required this.onDismissed,
    this.countdownSeconds = 15,
    this.onConfirm
  });

  @override
  State<PaymentCountdownDialog> createState() => _PaymentCountdownDialogState();
}

class _PaymentCountdownDialogState extends State<PaymentCountdownDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late int _secondsLeft;
  Timer? _timer;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.countdownSeconds;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
      });

      if (_secondsLeft <= 0) {
        timer.cancel();
        Navigator.of(context).pop();
        widget.onDismissed();
      }
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  double get _progress => _secondsLeft / widget.countdownSeconds;
  Color get _ringColor {
    if (_secondsLeft > 10) return const Color(0xFF4CAF50);
    if (_secondsLeft > 5) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 32,
                  offset: const Offset(0, -4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  child: Column(
                    children: [
                      // Animated countdown ring
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: _progress + 1 / widget.countdownSeconds, end: _progress),
                                duration: const Duration(milliseconds: 600),
                                builder: (context, value, _) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 5,
                                    backgroundColor: Colors.grey.withOpacity(0.15),
                                    valueColor: AlwaysStoppedAnimation<Color>(_ringColor),
                                    strokeCap: StrokeCap.round,
                                  );
                                },
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(scale: animation, child: child),
                                  child: Text(
                                    "$_secondsLeft",
                                    key: ValueKey(_secondsLeft),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      color: _ringColor,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                Text(
                                  "sec",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Complete Payment",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Your session will expire soon.\nPlease confirm to continue.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _timer?.cancel();
                                Navigator.of(context).pop();
                                widget.onDismissed();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child:  FilledButton(
                              onPressed: _isConfirming ? null : () async {
                                if(_isConfirming) return;
                                _timer?.cancel();
                                setState(() {
                                  _isConfirming = true;
                                });
                                await  widget.onConfirm?.call();
                              },
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: _ringColor,
                              ),
                              child: _isConfirming ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ): const Text(
                                "Confirm Payment",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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