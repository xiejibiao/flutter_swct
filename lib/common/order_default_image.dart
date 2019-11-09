import 'package:flutter/material.dart';

class OrderDefaultImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ImageIcon(AssetImage('assets/image_icon/icon_order.png'), size: 150, color: Colors.grey),
    );
  }
}