import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_settings_provider.dart';
import 'login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0e1116),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvider(),
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
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
