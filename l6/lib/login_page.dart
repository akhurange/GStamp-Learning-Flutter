import 'dart:math';

import 'package:flutter/material.dart';
import 'package:l6/progress_dialog.dart';
import 'package:toastification/toastification.dart';

import '../cloud/cloud_authentication.dart';
import 'max_width_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.auth, required this.loginCallBack});

  final CloudAuthentication auth;
  final VoidCallback loginCallBack;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _errorMessage = '';
  final TextEditingController _forgotPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaxWidthContainer(
        child: _showLoginPage(),
      ),
    );
  }

  Widget _showLoginPage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(8),
            ),
            width: min(
              460 * 1.0,
              MediaQuery.of(context).size.width - 2 * 24.0,
            ),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/eb_logo.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Text(
                  'LOGIN',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                _showForm(),
                _showForgotPasswordButton(),
                _showReleaseInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showForm() {
    return Form(
      key: _formKey,
      child: MaxWidthContainer(
        maxWidth: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showEmailInput(),
              const SizedBox(
                height: 16.0,
              ),
              showPasswordInput(),
              const SizedBox(
                height: 36.0,
              ),
              showLogInButton(),
              showErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14.0,
        ),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      validator: (value) =>
          (null == value || value.isEmpty) ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value!.trim(),
    );
  }

  Widget showPasswordInput() {
    return TextFormField(
      maxLines: 1,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14.0,
        ),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.lock,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      validator: (value) =>
          (null == value || value.isEmpty) ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value!.trim(),
    );
  }

  Widget showLogInButton() {
    return Align(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: validateAndSubmit,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
          child: Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          _errorMessage,
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  void validateAndSubmit() async {
    ProgressDialog pd = ProgressDialog(context, 'Signing In...');
    pd.show();
    // Validate the form first.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = "";
      });
      // After validating the form, save it.
      _formKey.currentState!.save();
      // Authenticate the user based on form entry for email & password.
      String userId = "";
      try {
        userId = await widget.auth.signIn(
          _email,
          _password,
        );
        /*if (!widget.auth.isEmailVerified()) {
          await widget.auth.sendEmailVerification();
          setState(() {
            pd.hide();
            widget.auth.signOut();
            // Reset the form.
            _formKey.currentState!.reset();
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Email Verification!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                content: RichText(
                  text: TextSpan(
                    text: 'Please check your inbox: ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: _email,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '\nVerification email has been sent.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text:
                            '\nComplete the verification step and then try to login.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {*/
//          DataRepository dataRepository = DataRepository();
//          await dataRepository.readAndSaveUserInfo(userId: userId);
//          await dataRepository.downloadCustomisedSetting();
        pd.hide();
        widget.loginCallBack();
        //       }
      } catch (e) {
        // Authentication failed.
        setState(() {
          pd.hide();
          widget.auth.signOut();
          // Set the error message.
          _errorMessage = e.toString();
          // Reset the form.
          _formKey.currentState!.reset();
        });
      }
    } else {
      pd.hide();
    }
  }

  Widget _showForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: forgotPassword,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void forgotPassword() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Forgot Password?',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).primaryColorDark),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter email address.'),
              const SizedBox(height: 24),
              TextField(
                controller: _forgotPasswordController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email Address',
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => _forgotPassword(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('CANCEL'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _forgotPassword() async {
    if (_forgotPasswordController.text.isEmpty) {
      return;
    }
    ProgressDialog pd = ProgressDialog(context, 'Resetting password...');
    pd.show();
    bool result =
        await widget.auth.passwordResetEmail(_forgotPasswordController.text);
    pd.hide();
    toastification.show(
      context: context,
      title: Text(result ? 'Success' : 'Error'),
      description: Text(result
          ? 'Check your email for password reset link.'
          : 'Failed to reset password.'),
      type: result ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.flatColored,
      animationDuration: const Duration(milliseconds: 300),
      applyBlurEffect: true,
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget _showReleaseInfo() {
    return const Row(
      children: [
        Spacer(),
        Text(
          'version: 0.1\n(12/03/2024)',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
