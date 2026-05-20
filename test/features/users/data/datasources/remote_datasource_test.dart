import 'package:flutter_project/features/users/data/datasources/remote_datasource.dart';
import 'package:flutter_project/features/users/data/models/UserModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRemoteDataSource extends Mock
    implements UsersRemoteDataSource {}

void main() {
  late MockUsersRemoteDataSource mockDataSource;

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
    mockDataSource = MockUsersRemoteDataSource();
  });

  group('UsersRemoteDataSource', () {
    group('getAllUsers', () {
      test('returns a list of UserModel on success', () async {
        when(() => mockDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        final result = await mockDataSource.getAllUsers();

        expect(result, isA<List<UserModel>>());
        expect(result.length, 2);
      });

      test('returns the correct UserModel data', () async {
        when(() => mockDataSource.getAllUsers())
            .thenAnswer((_) async => tUserModels);

        final result = await mockDataSource.getAllUsers();

        expect(result.first.id, 1);
        expect(result.first.name, 'Leanne Graham');
        expect(result.last.id, 2);
        expect(result.last.name, 'Ervin Howell');
      });

      test('returns an empty list when no users exist', () async {
        when(() => mockDataSource.getAllUsers()).thenAnswer((_) async => []);

        final result = await mockDataSource.getAllUsers();

        expect(result, isEmpty);
      });

      test('throws an Exception when the call fails', () async {
        when(() => mockDataSource.getAllUsers())
            .thenThrow(Exception('HTTP 500: Internal Server Error'));

        expect(
          () => mockDataSource.getAllUsers(),
          throwsA(isA<Exception>()),
        );
      });

      test('throws an Exception on network failure', () async {
        when(() => mockDataSource.getAllUsers())
            .thenThrow(Exception('Network unreachable'));

        expect(
          () => mockDataSource.getAllUsers(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
