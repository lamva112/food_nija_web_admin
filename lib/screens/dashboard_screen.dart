import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/controllers/MenuController.dart';
import 'package:food_nija_web_admin/inner_screens/add_prod.dart';
import 'package:food_nija_web_admin/inner_screens/add_res.dart';
import 'package:food_nija_web_admin/responsive.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/buttons.dart';
import 'package:food_nija_web_admin/widgets/grid_products.dart';
import 'package:food_nija_web_admin/widgets/grid_restauran.dart';
import 'package:food_nija_web_admin/widgets/header.dart';
import 'package:food_nija_web_admin/widgets/orders_list.dart';
import 'package:food_nija_web_admin/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../consts/constants.dart';
import '../inner_screens/all_restaurans.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                context.read<MenuController>().controlDashboarkMenu();
              },
              title: 'Dashboard',
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'restaurant',
              color: color,
              textSize: 24,
              isTitle: true,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllRestauransScreen(),
                          ),
                        );
                      },
                      text: 'View All',
                      icon: Icons.store,
                      backgroundColor: Colors.blue),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadrestaurantForm(),
                          ),
                        );
                      },
                      text: 'Add restaurant',
                      icon: Icons.add,
                      backgroundColor: Colors.blue),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: restaurantGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: restaurantGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      const OrdersList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
