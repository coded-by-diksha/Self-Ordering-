import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:spicebite/pages/navigationBar.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:spicebite/pages/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final globalState = GlobalState(); // Initialize global state
  
  runApp(
    KhaltiScope(
      navigatorKey: _navigatorKey,
      publicKey: '89d5ea819f7444d4a25264802e3981b7',
      enabledDebugging: true,
      builder: (context, navKey) => SpiceBiteApp(
        navigatorKey: _navigatorKey,
        globalState: globalState, // Pass global state
      ),
    ),
  );
}

class SpiceBiteApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalState globalState;
  
  const SpiceBiteApp({
    super.key, 
    required this.navigatorKey,
    required this.globalState,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceBite',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        KhaltiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ne', 'NP'), // Nepali
      ],
      home: WelcomeScreen(globalState: globalState),
    );
  }
}
class WelcomeScreen extends StatelessWidget {
  final GlobalState globalState;
  
  const WelcomeScreen({super.key, required this.globalState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Ensure this asset exists
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 100),
                ),
                Text(
                  '"Welcome to SpiceBite"\n Scan. Order. Enjoy.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scan the QR code on your table to view the menu and order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(selectedIndex: 0),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 41, 6),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Scan Now',
                    style: TextStyle(color: Color.fromARGB(221, 252, 252, 252)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}