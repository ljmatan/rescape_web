import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/cache/prefs.dart';
import 'package:rescape_web/ui/pages/admin/auth/auth_page.dart';
import 'package:rescape_web/ui/view/main_view.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureApp();

  await Prefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: const Color(0xff18191a),
        accentColor: const Color(0xff1A2098),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: UserData.authenticated ? MainView() : AuthPage(),
    );
  }
}
