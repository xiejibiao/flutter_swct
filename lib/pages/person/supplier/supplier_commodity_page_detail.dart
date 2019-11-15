import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SupplierCommodityPageDetail extends StatelessWidget {
  final String description;
  SupplierCommodityPageDetail(this.description);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: description,
    );
  }
}