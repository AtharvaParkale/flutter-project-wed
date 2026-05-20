import 'package:flutter_project/features/users/data/datasources/remote_datasource.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource _remoteDataSource;

  UsersRepositoryImpl({required UsersRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final remote = await _remoteDataSource.getAllUsers();
      return remote.map((item) => item as User).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
