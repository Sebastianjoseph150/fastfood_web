// import 'package:fastfoodweb/Screens/auth/auth_page.dart';
import 'package:fastfoodweb/Screens/splashscreen/splash_screen.dart';
import 'package:fastfoodweb/provider/auth_provider.dart';
import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:fastfoodweb/provider/restaurent_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBEsDMtjtKWuHtE-qcUkpKBlULA1vN-i1I",
          appId: "1:1012153674831:web:6440a7c08135f48c4f4e3a",
          messagingSenderId: "1012153674831",
          projectId: "fast-food-9fa24",
          storageBucket: "fast-food-9fa24.appspot.com"));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Provide ProductProvider
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add more providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast food ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
