import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import 'core/config/environment.dart';
import 'core/navigation/app_router.dart';
import 'shared/constants/strings.dart';
import 'shared/theme/app_theme.dart';
import 'core/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure drift to suppress multiple database warnings in debug mode
  // This is safe since we're using keepAlive: true for the database provider
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.error(
      'FlutterError: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  EnvironmentConfig.setEnvironment(Environment.development);

  runApp(const ProviderScope(child: CamperBlisApp()));
}

class CamperBlisApp extends StatelessWidget {
  const CamperBlisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
