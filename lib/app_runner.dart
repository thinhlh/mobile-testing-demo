import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfc/config/app_languages.dart';
import 'package:tfc/config/values.dart';
import 'package:tfc/services/local/shared_preferences/app_preference.dart';

import 'app/app.dart';

class AppRunner {
  AppRunner._internal();

  static final AppRunner instance = AppRunner._internal();

  Future<void> runApplication() async {
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Future.wait([
          _initializeDependencies(),
          _initServices(),
          _appConfigurations(),
        ]);
        runApp(const App());
      },
      (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
    );
  }

  /// Initalize application internal dependencies
  Future<void> _initializeDependencies() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// Initalize external application service
  Future<void> _initServices() async {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await AppPreferences.instance.init();
    await EasyLocalization.ensureInitialized();
    // await ScreenUtil.ensureScreenSize();
  }

  /// Initialize application configuration
  Future<void> _appConfigurations() async {
    Intl.defaultLocale = AppLanguages.defaultLanguage.countryCode;

    await SystemChrome.setPreferredOrientations(AppValues.deviceOrientations);
    EasyLocalization.logger.enableLevels = [];
  }
}
