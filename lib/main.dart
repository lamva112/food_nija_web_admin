import 'package:flutter/material.dart';
import 'package:food_nija_web_admin/inner_screens/add_prod.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'providers/dark_theme_provider.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBqVrKdHDL8ed4JIeA1FFeOZFSGyEHsQ9U",
      appId: "1:410962667981:web:c75067450a49752abdfc84",
      messagingSenderId: "410962667981",
      projectId: "food-ninja-app-66fcd",
      storageBucket: "food-ninja-app-66fcd.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuController(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Grocery',
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: const MainScreen(),
              routes: {});
        },
      ),
    );
  }
}
