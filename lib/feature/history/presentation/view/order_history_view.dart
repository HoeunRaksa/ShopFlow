import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/shared/app_scaffold.dart';

import '../widgets/order_history_body.dart';

class OrderHistoryView extends ConsumerWidget{
  final bool isSell;
  const OrderHistoryView({super.key, this.isSell = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      return AppScaffold(
        usePadding: false,
        body: OrderHistoryBody(isSell: isSell,),
      );
  }
}