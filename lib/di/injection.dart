import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_project/packages/core/logger/logger.dart';
import 'package:flutter_project/packages/core/analytics/analytics.dart';
import 'package:flutter_project/packages/core/network/network.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<Logger>(
    () => ConsoleLogger()..initialize(),
  );

  getIt.registerLazySingleton<AnalyticsService>(
    () => ConsoleAnalytics(),
  );

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      getIt<Dio>(),
      baseUrl: 'https://fakestoreapi.com',
    ),
  );
}
