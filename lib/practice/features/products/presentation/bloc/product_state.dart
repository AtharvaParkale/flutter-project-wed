part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class SuccessState extends ProductState {
  final List<Product> products;

  SuccessState({required this.products});
}

final class LoadingState extends ProductState {}

final class ErrorState extends ProductState {}
