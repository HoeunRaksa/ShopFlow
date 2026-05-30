import 'package:flutter/material.dart';
import '../core/app_style.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  final bool useSafeArea;
  final bool usePadding;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  final EdgeInsetsGeometry? padding;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.useSafeArea = false,
    this.usePadding = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.padding,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final defaultPadding = AppStyle.padding(context, w);

    Widget content = body;

    if (usePadding) {
      content = Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: defaultPadding * 0.5,
            ),
        child: content,
      );
    }

    if (useSafeArea) {
      content = SafeArea(
        child: content,
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      body: content,
    );
  }
}