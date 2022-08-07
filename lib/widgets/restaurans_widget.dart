import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/inner_screens/add_prod.dart';
import 'package:food_nija_web_admin/inner_screens/add_res.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({
    Key? key,
  }) : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'assets/images/RestaurantCake.png',
                        fit: BoxFit.fill,
                        width: size.width * 0.25,
                        height: size.width * 0.12,
                      ),
                    ),
                    // const Spacer(),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: InkWell(
                            onTap: (() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadProductForm(),
                                ),
                              );
                            }),
                            child: Text(
                              'Add Foods',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          value: 3,
                        ),
                        PopupMenuItem(
                          onTap: () {},
                          child: Text('Edit'),
                          value: 1,
                        ),
                        PopupMenuItem(
                          onTap: () {},
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          value: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: 'Healthy Food',
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
