import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/product_viewmodel.dart';
import 'views/product_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
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
      title: 'Interview Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151821), // Deep dark grey/blue background
        primaryColor: const Color(0xFF2B7EFE), // Vibrant neon blue
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2B7EFE),
          surface: Color(0xFF222634), // Elevated card color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151821),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}