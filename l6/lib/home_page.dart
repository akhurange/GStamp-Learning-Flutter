import 'package:flutter/material.dart';
import 'package:l6/root.dart';

import 'cloud/cloud_authentication.dart';

class HomePage extends StatefulWidget {
  final CloudAuthentication auth;
  final VoidCallback logoutCallBack;
  const HomePage({super.key, required this.auth, required this.logoutCallBack});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Project'),
        actions: [
          IconButton(
            onPressed: () {
              widget.auth.signOut();
              widget.logoutCallBack();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RootPage(auth: widget.auth),
                ),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
