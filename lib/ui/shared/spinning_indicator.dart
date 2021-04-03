import 'package:flutter/material.dart';

class CustomSpinningIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      onWillPop: () async => false,
    );
  }
}
