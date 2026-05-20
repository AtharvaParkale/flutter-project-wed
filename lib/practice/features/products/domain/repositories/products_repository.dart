import 'package:flutter_project/practice/features/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getAllProducts();
}
