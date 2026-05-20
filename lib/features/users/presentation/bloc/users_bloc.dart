import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_project/practice/usecase.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase _getUsersUseCase;

  UsersBloc({required GetUsersUseCase getUsersUseCase})
      : _getUsersUseCase = getUsersUseCase,
        super(UsersInitial()) {
    on<GetAllUsersEvent>(_onGetAllUsers);
  }

  Future<void> _onGetAllUsers(
    GetAllUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoadingState());
      final items = await _getUsersUseCase.call(NoParams());
      emit(UsersSuccessState(items: items));
    } catch (e) {
      emit(UsersErrorState(message: e.toString()));
    }
  }
}
