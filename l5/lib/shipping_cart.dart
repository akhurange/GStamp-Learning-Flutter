import 'package:flutter/material.dart';
import 'package:l5/cart_provider.dart';
import 'package:provider/provider.dart';

class ShippingCart extends StatefulWidget {
  const ShippingCart({super.key});

  @override
  State<ShippingCart> createState() => _ShippingCartState();
}

class _ShippingCartState extends State<ShippingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shipping Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider value, Widget? child) {
          return ListView.builder(
            itemCount: value.cart.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(value.cart[index].name),
                subtitle: Text(
                  '${value.cart[index].price} * ${value.cart[index].quantity} = ${value.cart[index].price * value.cart[index].quantity}',
                ),
                trailing: IconButton(
                  onPressed: () {
                    value.removeProduct(value.cart[index]);
                  },
                  icon: const Icon(Icons.remove_shopping_cart),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
