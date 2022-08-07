import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/responsive.dart';
import 'package:food_nija_web_admin/services/utils.dart';
import 'package:food_nija_web_admin/widgets/grid_products.dart';
import 'package:food_nija_web_admin/widgets/grid_restauran.dart';
import 'package:food_nija_web_admin/widgets/header.dart';
import 'package:food_nija_web_admin/widgets/side_menu.dart';

class AllRestauransScreen extends StatefulWidget {
  const AllRestauransScreen({Key? key}) : super(key: key);

  @override
  State<AllRestauransScreen> createState() => _AllRestauransScreenState();
}

class _AllRestauransScreenState extends State<AllRestauransScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      Header(
                        fct: () {},
                        title: 'All products',
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Responsive(
                        mobile: restaurantGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: restaurantGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
