import 'package:flutter_project/practice/features/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_project/practice/features/products/domain/entities/product.dart';
import 'package:flutter_project/practice/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getAllProducts() async {
    final List<dynamic> products = await datasource.getAllProducts();

    return products.map((elem) => elem as Product).toList();
  }
}
