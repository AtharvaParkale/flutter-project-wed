import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/repositories/users_repository.dart';
import 'package:flutter_project/practice/usecase.dart';

class GetUsersUseCase implements UseCase<List<User>, NoParams> {
  final UsersRepository _usersRepository;

  GetUsersUseCase({required UsersRepository usersRepository})
      : _usersRepository = usersRepository;

  @override
  Future<List<User>> call(NoParams params) async {
    return await _usersRepository.getAllUsers();
  }
}
