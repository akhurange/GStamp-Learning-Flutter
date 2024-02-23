import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:l4/bike.dart';
import 'package:l4/plane.dart';
import 'package:l4/responsive.dart';
import 'package:l4/truck.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selected = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: buildMobileView(context),
      desktop: buildDesktopView(context),
    );
  }

  Widget buildDesktopView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          _showNavigationRail(),
          const Divider(),
          Expanded(
            child: _showPageViewBody(),
          )
        ],
      ),
    );
  }

  Widget buildMobileView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _showPageViewBody(),
      bottomNavigationBar: _createBottomNavigation(),
    );
  }

  Widget _createBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selected,
      indicatorColor: Theme.of(context).colorScheme.primary,
      destinations: [
        NavigationDestination(
            icon: Icon(
              Icons.directions_bike_sharp,
              color: (0 == _selected ? Colors.white : Colors.black),
            ),
            label: 'Bike'),
        NavigationDestination(
            icon: Icon(
              Icons.fire_truck,
              color: (1 == _selected ? Colors.white : Colors.black),
            ),
            label: 'Truck'),
        NavigationDestination(
            icon: Icon(
              Icons.airplanemode_active,
              color: (2 == _selected ? Colors.white : Colors.black),
            ),
            label: 'Plane'),
      ],
      onDestinationSelected: (int index) {
        setState(() {
          _selected = index;
          _pageController.jumpToPage(_selected);
        });
      },
    );
  }

  Widget _showIndexedStackBody() {
    return IndexedStack(
      index: _selected,
      children: const [
        Bike(),
        Truck(),
        Plane(),
      ],
    );
  }

  Widget _showPageViewBody() {
    return PageView(
      controller: _pageController,
      children: const [
        Bike(),
        Truck(),
        Plane(),
      ],
      onPageChanged: (int index) {
        setState(() {
          _selected = index;
        });
      },
    );
  }

  Widget _showNavigationRail() {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      elevation: 8.0,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: FlutterLogo(),
      indicatorColor: Theme.of(context).colorScheme.primary,
      groupAlignment: 0,
      destinations: [
        NavigationRailDestination(
          icon: Icon(
            Icons.directions_bike_sharp,
            color: (0 == _selected ? Colors.white : Colors.black),
          ),
          label: const Text('Bike'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.fire_truck,
            color: (1 == _selected ? Colors.white : Colors.black),
          ),
          label: const Text('Truck'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.airplanemode_active,
            color: (2 == _selected ? Colors.white : Colors.black),
          ),
          label: const Text('Plane'),
        ),
      ],
      selectedIndex: _selected,
      onDestinationSelected: (int index) {
        setState(() {
          _selected = index;
          _pageController.jumpToPage(_selected);
        });
      },
    );
  }
}
