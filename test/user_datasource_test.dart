import 'dart:math';

import 'package:flutter_project/features/users/data/datasources/remote_datasource.dart';
import 'package:flutter_project/features/users/data/models/UserModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UsersRemoteDataSource usersRemoteDataSource;

  setUp(() {
    usersRemoteDataSource = UsersRemoteDatasourceImpl();
  });

  group("User Repository - ", () {
    group("Get user - ", () {
      test("Get all the users  : ", () async {
        final List<UserModel> users = await usersRemoteDataSource.getAllUsers();
        expect(users, isA<List<UserModel>>());
      });
    });
  });
}
