import 'package:flutter/material.dart';

import '../shared/theme.dart';

class ExpansionTileItem extends StatelessWidget {
  const ExpansionTileItem({
    required this.title,
    this.children = const [],
    Key? key,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final noDivider = Theme.of(context).copyWith(
      dividerColor: transparentColor,
    );

    return Theme(
      data: noDivider,
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.only(left: 24),
        title: Text(
          title,
          style: menuTitleStyle,
        ),
        children: children,
      ),
    );
  }
}
