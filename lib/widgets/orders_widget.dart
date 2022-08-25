import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/services/global_method.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class OrdersWidget extends StatefulWidget {
  final String orderId;

  const OrdersWidget({
    Key? key,
    required this.price,
    required this.totalPrice,
    required this.productId,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.quantity,
    required this.orderDate,
    required this.orderId,
  }) : super(key: key);
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateStr;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime date = DateTime.now();
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                          '${widget.quantity}X For \$${widget.price.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By',
                            color: Colors.blue,
                            textSize: 16,
                            isTitle: true,
                          ),
                          Text('  ${widget.userName}')
                        ],
                      ),
                    ),
                    Text(
                      orderDateStr,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  TextWidget(
                    text: "change status",
                    color: color,
                    textSize: 18,
                    isTitle: true,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            _updateStatus(
                              orderId: widget.orderId,
                              status: "Devivery",
                            );
                            _Addnotification(
                                userId: widget.userId,
                                foodPic:
                                    "https://firebasestorage.googleapis.com/v0/b/food-ninja-app-66fcd.appspot.com/o/notification%2Fsuccess.png?alt=media&token=6fe00812-43c3-4347-b6c7-84d80eb6bd3c",
                                title: "we are delivering your order");
                          },
                          child: Text(
                            'Devivery',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        value: 3,
                      ),
                      PopupMenuItem(
                        child: InkWell(
                            onTap: () {
                              _updateStatus(
                                  orderId: widget.orderId, status: "Complete");
                              _Addnotification(
                                  userId: widget.userId,
                                  foodPic:
                                      "https://firebasestorage.googleapis.com/v0/b/food-ninja-app-66fcd.appspot.com/o/notification%2Fsuccess.png?alt=media&token=6fe00812-43c3-4347-b6c7-84d80eb6bd3c",
                                  title: "your order is successfully");
                            },
                            child: Text('Complete')),
                        value: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateStatus({
    required String orderId,
    required String status,
  }) async {
    FocusScope.of(context).unfocus();

    try {
      FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': status,
      });
      await Fluttertoast.showToast(
        msg: "our information has been updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  Future<void> _Addnotification({
    required String userId,
    required String foodPic,
    required String title,
  }) async {
    try {
      String NotificationId = const Uuid().v1();
      _firestore
          .collection('users')
          .doc(userId)
          .collection('noti')
          .doc(NotificationId)
          .set({
        'profilePic': foodPic,
        'userId': userId,
        'title': title,
        "time": FieldValue.serverTimestamp(),
        "lasttime": DateFormat('hh:mm a').format(DateTime.now()),
        'date': DateFormat('yMMMMd').format(date),
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }
}
