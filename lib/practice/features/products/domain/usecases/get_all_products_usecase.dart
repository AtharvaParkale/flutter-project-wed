import 'package:flutter_project/practice/features/products/domain/entities/product.dart';
import 'package:flutter_project/practice/features/products/domain/repositories/products_repository.dart';
import 'package:flutter_project/practice/usecase.dart';

class GetAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductsRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}
