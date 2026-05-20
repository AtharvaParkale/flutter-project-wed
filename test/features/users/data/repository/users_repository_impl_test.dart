import 'package:flutter_project/features/users/data/datasources/remote_datasource.dart';
import 'package:flutter_project/features/users/data/models/UserModel.dart';
import 'package:flutter_project/features/users/data/repository/users_repository_impl.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRemoteDataSource extends Mock
    implements UsersRemoteDataSource {}

void main() {
  late MockUsersRemoteDataSource mockRemoteDataSource;
  late UsersRepositoryImpl repository;

  final tUserModels = [
    UserModel(
      id: 1,
      name: 'Leanne Graham',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031 x56442',
      website: 'hildegard.org',
    ),
    UserModel(
      id: 2,
      name: 'Ervin Howell',
      email: 'Shanna@melissa.tv',
      phone: '010-692-6593 x09125',
      website: 'anastasia.net',
    ),
  ];

  setUp(() {
    mockRemoteDataSource = MockUsersRemoteDataSource();
    repository = UsersRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('UsersRepositoryImpl', () {
    group('getAllUsers', () {
      test('calls remote datasource getAllUsers', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        await repository.getAllUsers();

        verify(() => mockRemoteDataSource.getAllUsers()).called(1);
      });

      test('returns a list of User entities on success', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        final result = await repository.getAllUsers();

        expect(result, isA<List<User>>());
      });

      test('returns the correct number of users', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        final result = await repository.getAllUsers();

        expect(result.length, tUserModels.length);
      });

      test('maps UserModel fields to User entity correctly', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        final result = await repository.getAllUsers();

        expect(result.first.id, 1);
        expect(result.first.name, 'Leanne Graham');
        expect(result.first.email, 'Sincere@april.biz');
        expect(result.first.phone, '1-770-736-8031 x56442');
        expect(result.first.website, 'hildegard.org');
      });

      test('returns an empty list when datasource returns no users', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenAnswer((_) async => []);

        final result = await repository.getAllUsers();

        expect(result, isEmpty);
      });

      test('throws an Exception when the datasource throws', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenThrow(Exception('Remote error'));

        expect(
          () => repository.getAllUsers(),
          throwsA(isA<Exception>()),
        );
      });

      test('does not swallow exceptions silently', () async {
        when(() => mockRemoteDataSource.getAllUsers())
            .thenThrow(Exception('Connection timeout'));

        try {
          await repository.getAllUsers();
          fail('Expected an Exception to be thrown');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });
  });
}
