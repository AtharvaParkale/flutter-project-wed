import 'dart:convert';

import 'package:flutter_project/practice/features/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_project/practice/features/products/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsRemoteDatasourceImpl implements ProductsRemoteDatasource {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final uri = Uri.parse("https://dummyjson.com/products");

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      final productsJson = body['products'] as List;

      return productsJson.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
