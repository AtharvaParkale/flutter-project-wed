import 'package:flutter_project/practice/features/products/data/models/product_model.dart';

abstract class ProductsRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
}
