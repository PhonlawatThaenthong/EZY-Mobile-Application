import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.initGoogleSignIn();

  // Listen to Google Sign-In authentication events (needed for Web renderButton)
  // When user signs in via Google's button on web, we get the event here
  // and use it to sign into Firebase Auth.
  GoogleSignIn.instance.authenticationEvents.listen((event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final idToken = event.user.authentication.idToken;
      if (idToken != null) {
        final credential = GoogleAuthProvider.credential(idToken: idToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFB2D8D8),
        fontFamily: 'Poppins',
      ),
      home: const AuthGate(),
    );
  }
}

/// Listens to Firebase auth state and routes accordingly.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFB2D8D8),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3A7CA5),
              ),
            ),
          );
        }

        // User is logged in → show HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // User is not logged in → show LoginPage
        return const LoginPage();
      },
    );
  }
}
