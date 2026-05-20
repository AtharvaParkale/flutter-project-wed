import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_project/practice/features/products/domain/entities/product.dart';
import 'package:flutter_project/practice/usecase.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase _getUsersUseCase;
  List<User> users = [];

  UsersBloc({required GetUsersUseCase getUsersUseCase})
    : _getUsersUseCase = getUsersUseCase,
      super(UsersInitial()) {
    on<GetAllUsersEvent>(_onGetAllUsers);
    on<SortByNameEvent>(_onSortByNameEvent);
    on<SortByIdEvent>(_onSortByIdEvent);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onGetAllUsers(
    GetAllUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoadingState());
      users = await _getUsersUseCase.call(NoParams());
      emit(UsersSuccessState(items: users));
    } catch (e) {
      emit(UsersErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onSortByNameEvent(
    SortByNameEvent event,
    Emitter<UsersState> emit,
  ) {
    users.sort((a, b) => a.name.compareTo(b.name));

    emit(UsersSuccessState(items: users));
  }

  FutureOr<void> _onSortByIdEvent(
    SortByIdEvent event,
    Emitter<UsersState> emit,
  ) {
    users.sort((a, b) => a.id.compareTo(b.id));
    emit(UsersSuccessState(items: users));
  }

  FutureOr<void> _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) {
    users.removeWhere((user) => event.id == user.id);
    emit(UsersSuccessState(items: users));
  }
}
