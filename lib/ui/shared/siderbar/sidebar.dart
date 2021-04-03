import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/ui/pages/customer/cart/bloc/cart_controller.dart';
import 'package:rescape_web/ui/shared/popup/logout_popup.dart';
import 'package:rescape_web/ui/shared/siderbar/button.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                child: UserData.isAdmin
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Zdravo, ' + UserData.instance.username!,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          StreamBuilder(
                            stream: CartItemsNumberController.stream,
                            initialData: CartItemsNumberController.initial,
                            builder: (context, itemsNumber) => SidebarButton(
                              label: 'Korpa' +
                                  (itemsNumber.hasData && itemsNumber.data != 0
                                      ? ' (${itemsNumber.data})'
                                      : ''),
                              index: 0,
                              icon: Icons.shopping_cart,
                            ),
                          ),
                        ],
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: UserData.isAdmin
                    ? [
                        SidebarButton(label: 'Porudžbe', index: 0),
                        SidebarButton(label: 'Proizvodi', index: 1),
                        SidebarButton(label: 'Kompanije', index: 2),
                        SidebarButton(label: 'Popusti', index: 3),
                        SidebarButton(label: 'Finansije', index: 4),
                        SidebarButton(label: 'Akcije', index: 5),
                      ]
                    : [
                        SidebarButton(label: 'Proizvodi', index: 1),
                        SidebarButton(label: 'Porudžbe', index: 2),
                        SidebarButton(label: 'Popusti', index: 3),
                        SidebarButton(label: 'Finansije', index: 4),
                        SidebarButton(label: 'Akcije', index: 5),
                      ],
              ),
              Positioned(
                bottom: 20,
                child: SidebarButton(
                  label: 'Odjavite se',
                  index: 6,
                  icon: Icons.logout,
                  onTap: () => PopupController.show(LogoutPopup()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
