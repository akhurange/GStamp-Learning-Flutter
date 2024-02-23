import 'package:flutter/material.dart';
import 'package:l2/welcome.dart';

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
      debugShowCheckedModeBanner: false,
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
  final List<TextEditingController> _textControllerList = [];
  String? _userName;
  String? _password;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 2; i++) {
      _textControllerList.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 2; i++) {
      _textControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _userNameTextField(),
                  const SizedBox(
                    height: 8,
                  ),
                  _passwordTextField(),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _userNameTextField() {
    return SizedBox(
      width: 400.0,
      child: TextFormField(
          //         controller: _textControllerList[0],
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: 'Enter your name',
            label: Text('User Name'),
            border: OutlineInputBorder(),
          ),
          onSaved: (String? value) => _userName = value!,
          validator: (String? value) {
            if (null == value || value.isEmpty) {
              return 'Please enter username';
            }
            return null;
          }),
    );
  }

  Widget _passwordTextField() {
    return SizedBox(
      width: 400.0,
      child: TextFormField(
          //        controller: _textControllerList[1],
          obscureText: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: 'Enter your password',
            label: Text('Password'),
            border: OutlineInputBorder(),
          ),
          onSaved: (String? value) => _password = value!,
          validator: (String? value) {
            if (null == value || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          }),
    );
  }

  Widget _submitButton() {
    return FilledButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print(_userName);
          print(_password);
        } else {
          print('invalid form');
        }
        _showProgressIndicator();
        bool result = await _authenticate();
        print(result);
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        if (true == result) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const WelcomeScree();
            },
          ));
        }
      },
      child: const Text('SUBMIT'),
    );
  }

  Future<bool> _authenticate() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  void _showProgressIndicator() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Dialog(
          child: SizedBox(
            width: 400,
            height: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Authenticating...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
