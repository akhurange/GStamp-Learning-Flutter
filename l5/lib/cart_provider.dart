import 'package:flutter/cupertino.dart';
import 'package:l5/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  double _price = 0;

  List<Product> get cart => _cart;
  double get price => _price;

  void addProductToCart(Product product) {
    _cart.add(product);
    _price += product.price * product.quantity;
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cart.remove(product);
    _price -= product.price * product.quantity;
    notifyListeners();
  }

  bool isProductPresent(Product product) {
    for (Product p in _cart) {
      if (p.name == product.name) {
        return true;
      }
    }
    return false;
  }
}
