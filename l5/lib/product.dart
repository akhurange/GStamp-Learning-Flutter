class Product {
  final String name;
  final double price;
  int quantity;

  Product({required this.name, required this.price, this.quantity = 0});
}

List<Product> myProductList = [
  Product(name: 'T Shirt', price: 199),
  Product(name: 'Jeans', price: 1029),
  Product(name: 'Travel Bag', price: 499),
  Product(name: 'Shoes', price: 3999),
  Product(name: 'Burger', price: 99),
];
