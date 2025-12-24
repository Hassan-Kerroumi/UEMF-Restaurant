import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/cart_provider.dart';
import 'login/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
     // Fix for "client is offline" error on web
    try {
      // clearPersistence() can help if the cache is corrupted
      await FirebaseFirestore.instance.clearPersistence().catchError((e) => debugPrint("Error clearing persistence: $e"));
      
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
      
      await FirebaseFirestore.instance.enableNetwork().catchError((e) => debugPrint("Error enabling network: $e"));
    } catch (e) {
      debugPrint("Could not set Firestore settings: $e");
    }
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_rounded, size: 60, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Firebase Configuration Needed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please open "lib/firebase_options.dart" and replace the placeholder strings with your actual Firebase project details.\n\nOR run "flutterfire configure" in your terminal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
    return;
  }
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0e1116),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Restaurant Admin',
          debugShowCheckedModeBanner: false,
          locale: Locale(settings.language),
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: settings.themeMode,
          // Dark theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF3cad2a),
            scaffoldBackgroundColor: const Color(0xFF0e1116),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3cad2a),
              secondary: Color(0xFF3cad2a),
              surface: Color(0xFF1a1f2e),
              onSurface: Color(0xFFf9fafb),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1a1f2e),
              elevation: 0,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          // Light theme
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF062c6b),
            scaffoldBackgroundColor: const Color(0xFFf5f5f5),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF062c6b),
              secondary: Color(0xFF3cad2a),
              surface: Colors.white,
              onSurface: Color(0xFF1a1a1a),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: IconThemeData(color: Color(0xFF1a1a1a)),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
