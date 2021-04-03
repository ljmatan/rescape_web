import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/cache/prefs.dart';
import 'package:rescape_web/ui/pages/customer/cart/bloc/cart_controller.dart';
import 'package:rescape_web/ui/view/bloc/view_page_controller.dart';

class MobileNavigationOption extends StatelessWidget {
  final String label;
  final int? index;
  final IconData? icon;

  MobileNavigationOption({required this.label, this.index, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon, color: Colors.white),
                ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: index != null
          ? () {
              ViewPageController.change(index);
              Navigator.pop(context);
            }
          : () async {
              for (var key in Prefs.instance.getKeys())
                await Prefs.instance.remove(key);
              html.window.location.reload();
            },
    );
  }
}

class MobileNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileNavigationState();
  }
}

class _MobileNavigationState extends State<MobileNavigation> {
  @override
  void initState() {
    super.initState();
    if (!UserData.isAdmin && CartItemsNumberController.streamController == null)
      CartItemsNumberController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: UserData.isAdmin
                  ? [
                      MobileNavigationOption(
                        label: 'Porudžbe',
                        index: 0,
                      ),
                      MobileNavigationOption(
                        label: 'Proizvodi',
                        index: 1,
                      ),
                      MobileNavigationOption(
                        label: 'Kompanije',
                        index: 2,
                      ),
                      MobileNavigationOption(
                        label: 'Popusti',
                        index: 3,
                      ),
                      MobileNavigationOption(
                        label: 'Finansije',
                        index: 4,
                      ),
                      MobileNavigationOption(
                        label: 'Akcije',
                        index: 5,
                      ),
                    ]
                  : [
                      MobileNavigationOption(
                        label: 'Korpa',
                        index: 0,
                        icon: Icons.shopping_cart,
                      ),
                      MobileNavigationOption(
                        label: 'Proizvodi',
                        index: 1,
                      ),
                      MobileNavigationOption(
                        label: 'Porudžbe',
                        index: 2,
                      ),
                      MobileNavigationOption(
                        label: 'Popusti',
                        index: 3,
                      ),
                      MobileNavigationOption(
                        label: 'Finansije',
                        index: 4,
                      ),
                      MobileNavigationOption(
                        label: 'Akcije',
                        index: 5,
                      ),
                    ],
            ),
            MobileNavigationOption(
              label: 'Odjavite se',
              icon: Icons.logout,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!UserData.isAdmin && CartItemsNumberController.streamController != null)
      CartItemsNumberController.dispose();
    super.dispose();
  }
}
