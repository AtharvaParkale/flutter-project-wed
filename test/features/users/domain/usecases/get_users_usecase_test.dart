import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_project/features/users/domain/repositories/users_repository.dart';
import 'package:flutter_project/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_project/practice/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late MockUsersRepository mockRepository;
  late GetUsersUseCase useCase;

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
  ];

  setUp(() {
    mockRepository = MockUsersRepository();
    useCase = GetUsersUseCase(usersRepository: mockRepository);
  });

  group('GetUsersUseCase', () {
    test('calls repository getAllUsers', () async {
      when(() => mockRepository.getAllUsers()).thenAnswer((_) async => tUsers);

      await useCase.call(NoParams());

      verify(() => mockRepository.getAllUsers()).called(1);
    });

    test('returns a list of User entities on success', () async {
      when(() => mockRepository.getAllUsers()).thenAnswer((_) async => tUsers);

      final result = await useCase.call(NoParams());

      expect(result, isA<List<User>>());
    });

    test('returns the exact list provided by the repository', () async {
      when(() => mockRepository.getAllUsers()).thenAnswer((_) async => tUsers);

      final result = await useCase.call(NoParams());

      expect(result.length, tUsers.length);
      expect(result.first.id, tUsers.first.id);
      expect(result.last.id, tUsers.last.id);
    });

    test('returns an empty list when repository returns no users', () async {
      when(() => mockRepository.getAllUsers()).thenAnswer((_) async => []);

      final result = await useCase.call(NoParams());

      expect(result, isEmpty);
    });

    test('propagates exception when repository throws', () async {
      when(() => mockRepository.getAllUsers())
          .thenThrow(Exception('Repository error'));

      expect(
        () => useCase.call(NoParams()),
        throwsA(isA<Exception>()),
      );
    });

    test('calls repository exactly once per call invocation', () async {
      when(() => mockRepository.getAllUsers()).thenAnswer((_) async => tUsers);

      await useCase.call(NoParams());
      await useCase.call(NoParams());

      verify(() => mockRepository.getAllUsers()).called(2);
    });
  });
}
