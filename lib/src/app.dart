import 'package:control_car/src/resource/home_page.dart';
import 'package:control_car/src/resource/login_page.dart';
import 'package:control_car/src/resource/splash_page.dart';
import 'package:control_car/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:control_car/src/utils/auth.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Control Car',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //auth.isAuth it coming from auth.dart
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
            future: auth.tryautoLogin(),
            builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? SplashPage()
                : LoginPage(),
          ),
        ),
      ),
    );
  }
}