import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_project/features/users/presentation/bloc/users_bloc.dart';
import 'package:flutter_project/practice/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late MockGetUsersUseCase mockUseCase;

  final tUsers = [
    User(
      id: 1,
      name: 'Leanne Graham',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031 x56442',
      website: 'hildegard.org',
    ),
    User(
      id: 2,
      name: 'Ervin Howell',
      email: 'Shanna@melissa.tv',
      phone: '010-692-6593 x09125',
      website: 'anastasia.net',
    ),
    User(
      id: 3,
      name: 'Clementine Bauch',
      email: 'Nathan@yesenia.net',
      phone: '1-463-123-4447',
      website: 'ramiro.info',
    ),
  ];

  // Unsorted by name: Charlie, Alice, Bob
  final tUsersUnsortedByName = [
    User(
      id: 3,
      name: 'Charlie',
      email: 'charlie@test.com',
      phone: '333',
      website: 'charlie.com',
    ),
    User(
      id: 1,
      name: 'Alice',
      email: 'alice@test.com',
      phone: '111',
      website: 'alice.com',
    ),
    User(
      id: 2,
      name: 'Bob',
      email: 'bob@test.com',
      phone: '222',
      website: 'bob.com',
    ),
  ];

  // Unsorted by id: 3, 1, 2
  final tUsersUnsortedById = [
    User(
      id: 3,
      name: 'Charlie',
      email: 'charlie@test.com',
      phone: '333',
      website: 'charlie.com',
    ),
    User(
      id: 1,
      name: 'Alice',
      email: 'alice@test.com',
      phone: '111',
      website: 'alice.com',
    ),
    User(
      id: 2,
      name: 'Bob',
      email: 'bob@test.com',
      phone: '222',
      website: 'bob.com',
    ),
  ];

  setUp(() {
    mockUseCase = MockGetUsersUseCase();
    registerFallbackValue(NoParams());
  });

  group('UsersBloc', () {
    test('initial state is UsersInitial', () {
      final bloc = UsersBloc(getUsersUseCase: mockUseCase);
      expect(bloc.state, isA<UsersInitial>());
      bloc.close();
    });

    test('initial users list is empty', () {
      final bloc = UsersBloc(getUsersUseCase: mockUseCase);
      expect(bloc.users, isEmpty);
      bloc.close();
    });

    // ── GetAllUsersEvent ──────────────────────────────────────────────────────

    group('GetAllUsersEvent', () {
      blocTest<UsersBloc, UsersState>(
        'emits [UsersLoadingState, UsersSuccessState] on success',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => tUsers);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        expect: () => [
          isA<UsersLoadingState>(),
          isA<UsersSuccessState>(),
        ],
      );

      blocTest<UsersBloc, UsersState>(
        'success state contains the list returned by the use case',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => tUsers);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        expect: () => [isA<UsersLoadingState>(), isA<UsersSuccessState>()],
        verify: (bloc) {
          final state = bloc.state as UsersSuccessState;
          expect(state.items.length, tUsers.length);
          expect(state.items.first.id, tUsers.first.id);
          expect(state.items.last.id, tUsers.last.id);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'populates internal users list after success',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => tUsers);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        verify: (bloc) {
          expect(bloc.users.length, tUsers.length);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits [UsersLoadingState, UsersErrorState] when use case throws',
        build: () {
          when(() => mockUseCase.call(any()))
              .thenThrow(Exception('Network error'));
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        expect: () => [
          isA<UsersLoadingState>(),
          isA<UsersErrorState>(),
        ],
      );

      blocTest<UsersBloc, UsersState>(
        'error state message contains the exception message',
        build: () {
          when(() => mockUseCase.call(any()))
              .thenThrow(Exception('Network error'));
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        verify: (bloc) {
          final state = bloc.state as UsersErrorState;
          expect(state.message, contains('Network error'));
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits [UsersLoadingState, UsersSuccessState] with empty list when use case returns no users',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(GetAllUsersEvent()),
        expect: () => [
          isA<UsersLoadingState>(),
          isA<UsersSuccessState>(),
        ],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items, isEmpty);
        },
      );
    });

    // ── SortByNameEvent ───────────────────────────────────────────────────────

    group('SortByNameEvent', () {
      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState with users sorted alphabetically by name',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = List.from(tUsersUnsortedByName);
          return bloc;
        },
        act: (bloc) => bloc.add(SortByNameEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          final items = (bloc.state as UsersSuccessState).items;
          expect(items[0].name, 'Alice');
          expect(items[1].name, 'Bob');
          expect(items[2].name, 'Charlie');
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState with an empty list when users is empty',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(SortByNameEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items, isEmpty);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState unchanged when list has a single user',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = [tUsers.first];
          return bloc;
        },
        act: (bloc) => bloc.add(SortByNameEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items.length, 1);
          expect((bloc.state as UsersSuccessState).items.first.id, tUsers.first.id);
        },
      );
    });

    // ── SortByIdEvent ─────────────────────────────────────────────────────────

    group('SortByIdEvent', () {
      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState with users sorted ascending by id',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = List.from(tUsersUnsortedById);
          return bloc;
        },
        act: (bloc) => bloc.add(SortByIdEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          final items = (bloc.state as UsersSuccessState).items;
          expect(items[0].id, 1);
          expect(items[1].id, 2);
          expect(items[2].id, 3);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState with an empty list when users is empty',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          return UsersBloc(getUsersUseCase: mockUseCase);
        },
        act: (bloc) => bloc.add(SortByIdEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items, isEmpty);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState unchanged when list has a single user',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = [tUsers.first];
          return bloc;
        },
        act: (bloc) => bloc.add(SortByIdEvent()),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items.length, 1);
        },
      );
    });

    // ── DeleteUser ────────────────────────────────────────────────────────────

    group('DeleteUser', () {
      blocTest<UsersBloc, UsersState>(
        'emits UsersSuccessState without the deleted user',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = List.from(tUsers);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteUser(id: 1)),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          final items = (bloc.state as UsersSuccessState).items;
          expect(items.length, tUsers.length - 1);
          expect(items.any((u) => u.id == 1), isFalse);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'deleting the only user emits UsersSuccessState with an empty list',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = [tUsers.first];
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteUser(id: tUsers.first.id)),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items, isEmpty);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'deleting a non-existent id does not change the list',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = List.from(tUsers);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteUser(id: 9999)),
        expect: () => [isA<UsersSuccessState>()],
        verify: (bloc) {
          expect((bloc.state as UsersSuccessState).items.length, tUsers.length);
        },
      );

      blocTest<UsersBloc, UsersState>(
        'can delete multiple users sequentially',
        build: () {
          when(() => mockUseCase.call(any())).thenAnswer((_) async => []);
          final bloc = UsersBloc(getUsersUseCase: mockUseCase);
          bloc.users = List.from(tUsers);
          return bloc;
        },
        act: (bloc) async {
          bloc.add(DeleteUser(id: 1));
          await Future.delayed(Duration.zero);
          bloc.add(DeleteUser(id: 2));
        },
        verify: (bloc) {
          final items = (bloc.state as UsersSuccessState).items;
          expect(items.any((u) => u.id == 1), isFalse);
          expect(items.any((u) => u.id == 2), isFalse);
          expect(items.length, tUsers.length - 2);
        },
      );
    });

    // ── UsersErrorState default message ───────────────────────────────────────

    group('UsersErrorState', () {
      test('has default message when none is provided', () {
        final state = UsersErrorState();
        expect(state.message, 'Something went wrong');
      });

      test('uses the provided message when given', () {
        final state = UsersErrorState(message: 'Custom error');
        expect(state.message, 'Custom error');
      });
    });
  });
}
