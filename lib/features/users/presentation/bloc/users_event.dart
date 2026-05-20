part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class GetAllUsersEvent extends UsersEvent {}

class SortByNameEvent extends UsersEvent {}

class SortByIdEvent extends UsersEvent {}

class DeleteUser extends UsersEvent {
  final int id;

  DeleteUser({required this.id});
}
