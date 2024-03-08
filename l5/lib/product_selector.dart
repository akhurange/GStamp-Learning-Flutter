import 'package:flutter/material.dart';
import 'package:l5/cart_provider.dart';
import 'package:l5/product.dart';
import 'package:provider/provider.dart';

class ProductSelector extends StatefulWidget {
  final Product product;
  const ProductSelector({super.key, required this.product});

  @override
  State<ProductSelector> createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
          ),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    CartProvider provider =
                        Provider.of<CartProvider>(context, listen: false);
                    provider.addProductToCart(
                      Product(
                        name: widget.product.name,
                        price: widget.product.price,
                        quantity: int.parse(_textEditingController.text),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('ADD'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
