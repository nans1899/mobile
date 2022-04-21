import 'package:flutter/material.dart';

import '../shared/theme.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    required this.title,
    this.isSelected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: menuTitleStyle,
      ),
      selected: isSelected,
      selectedTileColor: isSelected ? blueColor : yellowColor,
      onTap: onTap,
    );
  }
}
