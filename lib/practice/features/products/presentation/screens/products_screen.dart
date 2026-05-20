import 'package:flutter/material.dart';
import 'package:flutter_project/practice/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductBloc>().add(GetAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Products")),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {},
        buildWhen: (prev, curr) =>
            curr is LoadingState || curr is ErrorState || curr is SuccessState,
        builder: (context, state) {
          if (state is ErrorState) {
            return Center(child: Text("Error !"));
          } else if (state is SuccessState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (BuildContext context, int count) {
                  return ListTile(
                    title: Text(state.products[count].title ?? "NA"),
                  );
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
