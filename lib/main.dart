import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/colors.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (using DefaultFirebaseOptions from android/app/google-services.json)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Citrus AI: Firebase initialized successfully.');

    // Initialize Firebase App Check
    // Play Integrity for production, Debug provider for development builds only
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
      debugPrint('Citrus AI: App Check activated (Debug: $kDebugMode).');
    } catch (e) {
      debugPrint('Citrus AI: App Check initialization notice: $e');
    }

    // Automatic anonymous authentication session
    try {
      await AuthService().ensureAuthenticated();
    } catch (e) {
      debugPrint('Citrus AI: Auth session notice: $e');
    }
  } catch (e) {
    debugPrint('Citrus AI: Firebase initialization notice: $e');
  }

  // Lock orientation to portrait for phones
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.warmCream,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CitrusAIApp());
}

class CitrusAIApp extends StatelessWidget {
  const CitrusAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citrus AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
