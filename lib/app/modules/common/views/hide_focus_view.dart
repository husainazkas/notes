import 'package:flutter/material.dart';

import '../utils/widget_utils.dart';

class HideFocus extends StatelessWidget {
  final Widget child;

  const HideFocus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () => unfocus(context),
    );
  }
}
