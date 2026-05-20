part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoadingState extends UsersState {}

final class UsersSuccessState extends UsersState {
  final List<User> items;
  UsersSuccessState({required this.items});
}

final class UsersErrorState extends UsersState {
  final String message;
  UsersErrorState({this.message = 'Something went wrong'});
}
