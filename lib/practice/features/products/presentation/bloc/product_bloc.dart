import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_project/practice/features/products/domain/entities/product.dart';
import 'package:flutter_project/practice/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:flutter_project/practice/usecase.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase _getAllProductsUseCase;

  ProductBloc({required GetAllProductsUseCase getAllProductsUseCase})
    : _getAllProductsUseCase = getAllProductsUseCase,
      super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
    on<GetAllProductsEvent>(_onGetAllProductsEvent);
  }

  Future<void> _onGetAllProductsEvent(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    final products = await _getAllProductsUseCase.call(NoParams());

    if (products.isEmpty) {
      emit(ErrorState());
    } else {
      emit(SuccessState(products: products));
    }
  }
}
