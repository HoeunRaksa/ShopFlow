import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/shared/app_bar_icon_button.dart';
import '../widgets/location_form.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    late final maxWidth = AppStyle.maxWidth(context);
    final padding = AppStyle.padding(context, w);
    final iconSize = AppStyle.iconSize(context, w);
    final titleSize = AppStyle.titleSize(context, w);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back_ios,
          iconSize: iconSize,
          onPressed: () => context.pop(),
        ),
        title: Text(
          "CheckOut",
          style: TextStyle(
            fontSize: titleSize,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: LocationForm(),
            ),
          ),
        ),
      ),
    );
  }
}
