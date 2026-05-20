import 'package:flutter_project/features/users/domain/entities/User.dart';

abstract interface class UsersRepository {
  Future<List<User>> getAllUsers();
}
