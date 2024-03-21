import 'package:flutter/material.dart';
import 'package:l7/navigation_bar.dart';
import 'package:l7/profile.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
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
      body: Row(
        children: [
          _navigationContainer(),
          const VerticalDivider(
            color: Colors.white,
          ),
          _bodyContainer(),
          const Divider(
            thickness: 1,
            color: Colors.white,
          ),
          _profileContainer(),
          const Divider(
            thickness: 1,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _navigationContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      child: const MyNavigationBar(),
    );
  }

  Widget _bodyContainer() {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width * 0.55,
      height: MediaQuery.of(context).size.height,
    );
  }

  Widget _profileContainer() {
    return const Expanded(
      child: Profile(),
    );
  }
}
