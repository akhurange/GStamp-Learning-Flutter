import 'package:flutter/material.dart';

import 'cloud/cloud_authentication.dart';
import 'cloud/cloud_connector.dart';
import 'home_page.dart';
import 'login_page.dart';

enum AuthStatus {
  notDetermined,
  notLoggedIn,
  loggedIn,
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.auth});

  final CloudAuthentication auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notDetermined;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() async {
    bool isAuthenticatedUser = await widget.auth.isAuthenticatedUser();
    setState(() {
      _authStatus =
          isAuthenticatedUser ? AuthStatus.loggedIn : AuthStatus.notLoggedIn;
    });
  }

  void loginCallBack() async {
    {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  void logoutCallBack() {
    setState(() {
      _authStatus = AuthStatus.notLoggedIn;
    });
  }

  Widget buildWaitingScreen() {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 16,
            ),
            Text(
              'Loading ...',
              style: TextStyle(
                fontSize: 28.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      switch (_authStatus) {
        case AuthStatus.notDetermined:
          return buildWaitingScreen();
        case AuthStatus.notLoggedIn:
          return LoginPage(
            auth: widget.auth,
            loginCallBack: loginCallBack,
          );
        case AuthStatus.loggedIn:
          if (widget.auth.isLoggedIn) {
            _setCrashlyticsCustomKeys();
            return HomePage(
              auth: widget.auth,
              logoutCallBack: logoutCallBack,
            );
            /*          Future<Widget?> homePage = homePageFactory.getHomePage();
            return FutureBuilder(
              future: homePage,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  widget.auth.signOut();
                  return LoginPhonePage(
                    auth: widget.auth,
                    loginCallBack: loginCallBack,
                  );
                }
                if (!snapshot.hasData) {
                  return buildWaitingScreen();
                } else {
                  return snapshot.data;
                }
              },
            );*/
          } else {
            return buildWaitingScreen();
          }
      }
    } catch (e) {
      CloudConnector.crashlyticsLog('Caught error on root page.');
      widget.auth.signOut();
      logoutCallBack();
      return LoginPage(
        auth: widget.auth,
        loginCallBack: loginCallBack,
      );
    }
  }

  void _setCrashlyticsCustomKeys() {
    /*  DataRepository dataRepository = DataRepository();
    // Set the crashlytics custom keys
    CloudConnector.setCrashlyticsKeys(
      dataRepository.getMyName(),
      dataRepository.getMyUserId(),
    );*/
  }
}
