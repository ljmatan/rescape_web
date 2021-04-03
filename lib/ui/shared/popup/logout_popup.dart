// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:rescape_web/logic/cache/prefs.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class LogoutPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: const [BoxShadow(blurRadius: 8)],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: const EdgeInsets.only(bottom: 26),
                child: Text(
                  'Odjaviti se sa portala?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Text('Da'),
                    onPressed: () async {
                      for (var key in Prefs.instance.getKeys())
                        await Prefs.instance.remove(key);
                      html.window.location.reload();
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    child: Text('Ne'),
                    onPressed: () => PopupController.hide(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
