import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {

  final double width;
  final double height;

  ShimmerWidget.rectangular({ Key? key, this.width = double.infinity, required this.height }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade400,
      ),
    );
  }
}
