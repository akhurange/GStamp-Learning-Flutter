import 'package:flutter/material.dart';

class WelcomeScree extends StatefulWidget {
  const WelcomeScree({super.key});

  @override
  State<WelcomeScree> createState() => _WelcomeScreeState();
}

class _WelcomeScreeState extends State<WelcomeScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: FutureBuilder(
        future: _sendNames(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch data'),
            );
          } else {
            List<String> names = snapshot.data!;
            return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(names[index]),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _sendNames() async {
    await Future.delayed(const Duration(seconds: 10));
    return ['ashish', 'arun', 'tushar', 'mukul'];
  }
}
