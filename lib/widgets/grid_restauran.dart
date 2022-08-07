import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/consts/constants.dart';
import 'package:food_nija_web_admin/widgets/products_widget.dart';
import 'package:food_nija_web_admin/widgets/restaurans_widget.dart';

class restaurantGridWidget extends StatelessWidget {
  const restaurantGridWidget(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isInMain ? 4 : 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
        ),
        itemBuilder: (context, index) {
          return RestaurantWidget();
        });
  }
}