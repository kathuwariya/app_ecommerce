import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk_app/favorite_products_provider.dart';
import 'package:uk_app/screens/home_screen.dart';
import 'package:uk_app/screens/login_screen.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ' AIzaSyCJKD_oMPZNljpAwvlcJnS7DBDmini6xiM ',
          appId: '1:709002571189:android:0e3af86fe1532b3f5abdfc',
          messagingSenderId: '709002571189',
          projectId: 'productapp-b6f33',
          storageBucket: 'gs://productapp-b6f33.appspot.com'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FavoriteProductsProvider()),
      ],
      child: MaterialApp(
        title: 'Web 3.0 Commerce',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? HomeScreen()
            : LoginScreen(),
      ),
    );
  }
}
