class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

List<Product> cakesList = [
  Product(name: 'Chocolate', price: 196.99),
  Product(name: 'Black Forest', price: 196.99),
  Product(name: 'Pineapple', price: 196.99),
  Product(name: 'Vanilla', price: 286.99),
  Product(name: 'Strawberry', price: 299.99),
  Product(name: 'Dutch truffle', price: 388.99),
];

List<Product> pastriesList = [
  Product(name: 'Chocolate', price: 25),
  Product(name: 'Black Forest', price: 45),
  Product(name: 'Pineapple', price: 80),
  Product(name: 'Vanilla', price: 20),
  Product(name: 'Strawberry', price: 100),
  Product(name: 'Dutch truffle', price: 35),
];

List<Product> biscuitsList = [
  Product(name: 'Parle G', price: 25),
  Product(name: 'Britania', price: 25),
];
