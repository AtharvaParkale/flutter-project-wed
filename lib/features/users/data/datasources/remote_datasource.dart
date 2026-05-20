import 'dart:convert';

import 'package:flutter_project/features/users/data/models/UserModel.dart';
import 'package:http/http.dart' as http;

abstract interface class UsersRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
}

class UsersRemoteDatasourceImpl implements UsersRemoteDataSource {
  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UserModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
