import 'package:flutter_project/features/users/data/models/UserModel.dart';
import 'package:flutter_project/features/users/domain/entities/User.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tName = 'Leanne Graham';
  const tEmail = 'Sincere@april.biz';
  const tPhone = '1-770-736-8031 x56442';
  const tWebsite = 'hildegard.org';

  final tUserModel = UserModel(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    website: tWebsite,
  );

  final tJson = {
    'id': tId,
    'name': tName,
    'email': tEmail,
    'phone': tPhone,
    'website': tWebsite,
  };

  group('UserModel', () {
    test('is a subtype of User entity', () {
      expect(tUserModel, isA<User>());
    });

    test('exposes all fields from the User entity', () {
      expect(tUserModel.id, tId);
      expect(tUserModel.name, tName);
      expect(tUserModel.email, tEmail);
      expect(tUserModel.phone, tPhone);
      expect(tUserModel.website, tWebsite);
    });

    group('fromJson', () {
      test('returns a valid UserModel when all fields are present', () {
        final result = UserModel.fromJson(tJson);

        expect(result.id, tId);
        expect(result.name, tName);
        expect(result.email, tEmail);
        expect(result.phone, tPhone);
        expect(result.website, tWebsite);
      });

      test('returns a UserModel that is a subtype of User', () {
        final result = UserModel.fromJson(tJson);

        expect(result, isA<User>());
      });

      test('correctly parses numeric id field', () {
        final json = {...tJson, 'id': 42};
        final result = UserModel.fromJson(json);

        expect(result.id, 42);
      });

      test('correctly parses different user data', () {
        final json = {
          'id': 7,
          'name': 'Kurtis Weissnat',
          'email': 'Telly.Hoeger@billy.biz',
          'phone': '210.067.6132',
          'website': 'elvis.io',
        };
        final result = UserModel.fromJson(json);

        expect(result.id, 7);
        expect(result.name, 'Kurtis Weissnat');
        expect(result.email, 'Telly.Hoeger@billy.biz');
        expect(result.phone, '210.067.6132');
        expect(result.website, 'elvis.io');
      });
    });

    group('toJson', () {
      test('returns a Map with all required keys', () {
        final result = tUserModel.toJson();

        expect(result.containsKey('id'), isTrue);
        expect(result.containsKey('name'), isTrue);
        expect(result.containsKey('email'), isTrue);
        expect(result.containsKey('phone'), isTrue);
        expect(result.containsKey('website'), isTrue);
      });

      test('returns a Map with correct values', () {
        final result = tUserModel.toJson();

        expect(result['id'], tId);
        expect(result['name'], tName);
        expect(result['email'], tEmail);
        expect(result['phone'], tPhone);
        expect(result['website'], tWebsite);
      });

      test('toJson and fromJson are inverse operations', () {
        final json = tUserModel.toJson();
        final result = UserModel.fromJson(json);

        expect(result.id, tUserModel.id);
        expect(result.name, tUserModel.name);
        expect(result.email, tUserModel.email);
        expect(result.phone, tUserModel.phone);
        expect(result.website, tUserModel.website);
      });
    });
  });
}
