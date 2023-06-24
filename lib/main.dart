import 'package:flutter/material.dart';
import 'package:flutter_project_market/screens/home.dart';
import 'package:flutter_project_market/screens/verify_email.dart';
import 'package:flutter_project_market/shared/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'provider/cart.dart';
import 'provider/google_signin.dart';
import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
      return MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) {
    return Cart();
    }),
    ChangeNotifierProvider(create: (context) {
     return GoogleSignInProvider();
    }),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const VerifyEmailView();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
