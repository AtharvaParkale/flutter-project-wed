import 'package:flutter/material.dart';
import 'package:flutter_project/di/injection.dart';
import 'package:flutter_project/packages/design/design_system/design_system.dart';
import 'package:flutter_project/practice/features/layout_practice.dart';

void main() {
  setupDependencies();
  runApp(const TamaraApp());
}

class TamaraApp extends StatelessWidget {
  const TamaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamara Products',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const LayoutPractice(),
    );
  }
}


class ProductsPlaceholderScreen extends StatelessWidget {
  const ProductsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello World!',
                style: AppTypography.title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
