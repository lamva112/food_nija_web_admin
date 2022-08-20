import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/inner_screens/add_prod.dart';
import 'package:food_nija_web_admin/inner_screens/add_res.dart';
import 'package:food_nija_web_admin/services/global_method.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantWidget extends StatefulWidget {
  final String id;
  const RestaurantWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  String ResName = "";
  String Time = '';
  String? imageUrl;

  @override
  void initState() {
    getRestaurantsData();
    super.initState();
  }

  Future<void> getRestaurantsData() async {
    try {
      final DocumentSnapshot restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.id)
          .get();
      if (restaurantDoc == null) {
        return;
      } else {
        setState(() {
          ResName = restaurantDoc.get('resName');
          Time = restaurantDoc.get('time');
          imageUrl = restaurantDoc.get('imageUrl');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

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
                      child: Image.network(
                        imageUrl == null
                            ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                            : imageUrl!,
                        fit: BoxFit.fill,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    // const Spacer(),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          // ignore: sort_child_properties_last
                          child: InkWell(
                            onTap: (() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadProductForm(
                                    id: widget.id,
                                    resName: ResName,
                                  ),
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
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: ResName,
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
