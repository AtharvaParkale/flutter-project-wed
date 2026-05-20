import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/di/injection.dart';
import 'package:flutter_project/features/counter/counter_screen.dart';
import 'package:flutter_project/features/users/presentation/ui/screens/users_screen.dart';
import 'package:flutter_project/packages/design/design_system/design_system.dart';
import 'package:flutter_project/practice/features/form_practice.dart';
import 'package:flutter_project/practice/features/layout_practice.dart';
import 'package:flutter_project/practice/features/products/data/datasources/products_remote_datasource_impl.dart';
import 'package:flutter_project/practice/features/products/data/repositories/products_repository_impl.dart';
import 'package:flutter_project/practice/features/products/domain/repositories/products_repository.dart';
import 'package:flutter_project/practice/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:flutter_project/practice/features/products/presentation/bloc/product_bloc.dart';

import 'practice/features/products/presentation/screens/products_screen.dart';

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

      // home: BlocProvider(
      //   create: (BuildContext context) => ProductBloc(
      //     getAllProductsUseCase: GetAllProductsUseCase(
      //       ProductsRepositoryImpl(ProductsRemoteDatasourceImpl()),
      //     ),
      //   ),
      //   child: UsersScreen(),
      // ),
      home: CounterScreen(title: "Counter Screen"),
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
