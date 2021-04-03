import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/auth.dart';
import 'package:rescape_web/ui/pages/admin/auth/terms_and_conditions.dart';
import 'package:rescape_web/ui/view/main_view.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _validating = false;

  bool _termsDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  child: const Text(
                    'USLOVI KORIŠĆENJA',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => setState(() => _termsDisplayed = true),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: constraints.maxWidth > 896
                    ? 400
                    : MediaQuery.of(context).size.width,
                child: Padding(
                  padding: constraints.maxWidth > 896
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: constraints.maxWidth > 896
                              ? 400
                              : MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      TextField(
                        autofocus: true,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Username',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 20),
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, newState) => InkWell(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: SizedBox(
                              width: 200,
                              height: 56,
                              child: Center(
                                child: _validating
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'LOGIN',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          onTap: _validating
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  newState(() => _validating = true);

                                  final bool successfullyAuthenticated =
                                      await AuthAPI.login(
                                    _usernameController.text,
                                    _passwordController.text,
                                  );

                                  if (successfullyAuthenticated) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MainView()),
                                        (Route<dynamic> route) => false);
                                  }

                                  if (!successfullyAuthenticated) {
                                    newState(() => _validating = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Prijava neuspešna. Molimo proverite svoje podatke.')));
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_termsDisplayed)
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: TermsAndConditions(
                  hide: () => setState(() => _termsDisplayed = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
