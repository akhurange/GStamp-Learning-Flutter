import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../firebase_options.dart';
import 'cloud_database.dart';

class CloudConnector {
  static Future<void> initializeCloud() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return;
  }

  static Future<void> refreshDbConnection() async {
    await initializeCloud();
    await CloudDatabase.refreshConnectivity();
    return;
  }

  static void setCrashlyticsKeys(String companyId, String userId) {
    FirebaseCrashlytics.instance.setCustomKey('companyId', companyId);
    FirebaseCrashlytics.instance.setCustomKey('userId', userId);
  }

  static void crashlyticsLog(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
}
