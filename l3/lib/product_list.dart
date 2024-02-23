import 'package:flutter/material.dart';
import 'package:l3/product.dart';

class ProductList extends StatefulWidget {
  final int index;
  const ProductList({super.key, required this.index});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchProductList(widget.index),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error!'),
          );
        } else {
          List<Product> productList = snapshot.data!;
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.pink[100],
                  title: Text(productList[index].name),
                  subtitle: Text(productList[index].price.toString()),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<Product>> _fetchProductList(int index) async {
    await Future.delayed(const Duration(seconds: 5));
    late List<Product> productList;

    switch (index) {
      case 0:
        productList = cakesList;
        break;
      case 1:
        productList = pastriesList;
        break;
      default:
        productList = biscuitsList;
        break;
    }
    return productList;
  }
}
