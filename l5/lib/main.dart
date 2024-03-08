import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:l5/cart_provider.dart';
import 'package:l5/product.dart';
import 'package:l5/product_selector.dart';
import 'package:l5/shipping_cart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My eCommerce Site'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer<CartProvider>(
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ShippingCart(),
                  ));
                },
                child: Badge(
                  label: Text(value.cart.length.toString()),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder:
                  (BuildContext context, CartProvider value, Widget? child) =>
                      ListView.builder(
                          itemCount: myProductList.length,
                          itemBuilder: (context, index) {
                            if (value.isProductPresent(myProductList[index])) {
                              return Banner(
                                  location: BannerLocation.topStart,
                                  message: 'ADDED',
                                  child: _productCard(myProductList[index]));
                            } else {
                              return _productCard(myProductList[index]);
                            }
                          }),
            ),
          ),
          _buildBottomBanner(),
        ],
      ),
    );
  }

  Widget _productCard(Product product) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.price.toString()),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductSelector(product: product),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.indianRupeeSign,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Consumer<CartProvider>(
              builder: (context, value, child) => Text(value.price.toString()),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShippingCart(),
                  ),
                );
              },
              child: const Row(
                children: [
                  Text('Place Order'),
                ],
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
