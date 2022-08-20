import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/services/global_method.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductWidget extends StatefulWidget {
  final String id;
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String foodName = '';
  String resName = '';
  String imageUrl = '';
  String price = '0.0';

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('foods')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          foodName = productsDoc.get('foodName');
          resName = productsDoc.get('resName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
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
                        imageUrl,
                        fit: BoxFit.fill,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {},
                          child: Text('Edit'),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: InkWell(
                            onTap: (() {}),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          value: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: '\$' + price,
                  color: color,
                  textSize: 12,
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: foodName,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: resName,
                  color: Colors.grey,
                  textSize: 18,
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
