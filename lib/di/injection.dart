import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_project/features/users/data/datasources/remote_datasource.dart';
import 'package:flutter_project/features/users/data/repository/users_repository_impl.dart';
import 'package:flutter_project/features/users/domain/repositories/users_repository.dart';
import 'package:flutter_project/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_project/features/users/presentation/bloc/users_bloc.dart';
import 'package:flutter_project/packages/core/logger/logger.dart';
import 'package:flutter_project/packages/core/analytics/analytics.dart';
import 'package:flutter_project/packages/core/network/network.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<Logger>(() => ConsoleLogger()..initialize());

  getIt.registerLazySingleton<AnalyticsService>(() => ConsoleAnalytics());

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>(), baseUrl: 'https://fakestoreapi.com'),
  );

  // Users feature
  getIt.registerFactory<UsersRemoteDataSource>(
    () => UsersRemoteDatasourceImpl(),
  );
  getIt.registerFactory<UsersRepository>(
    () => UsersRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerFactory<GetUsersUseCase>(
    () => GetUsersUseCase(usersRepository: getIt()),
  );
  getIt.registerFactory<UsersBloc>(() => UsersBloc(getUsersUseCase: getIt()));
}
