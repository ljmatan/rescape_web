import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/discounted_data.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/discounted_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/companies_page.dart';
import 'package:rescape_web/ui/pages/admin/discounts/discounts_page.dart';
import 'package:rescape_web/ui/pages/admin/finances/finances_page.dart';
import 'package:rescape_web/ui/pages/admin/specials/specials_page.dart';
import 'package:rescape_web/ui/pages/customer/cart/bloc/cart_controller.dart';
import 'package:rescape_web/ui/pages/customer/cart/cart_page.dart';
import 'package:rescape_web/ui/pages/customer/discounts/discounts_page.dart';
import 'package:rescape_web/ui/pages/customer/finances/finances_page.dart';
import 'package:rescape_web/ui/pages/customer/orders/orders_page.dart';
import 'package:rescape_web/ui/pages/customer/product_list/products_list_page.dart';
import 'package:rescape_web/ui/pages/customer/specials/specials_page.dart';
import 'package:rescape_web/ui/shared/popup/animated_popup.dart';
import 'package:rescape_web/ui/shared/siderbar/mobile/mobile_navigation.dart';
import 'package:rescape_web/ui/shared/siderbar/sidebar.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_page.dart';
import 'package:rescape_web/ui/pages/admin/orders/orders_page.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';
import 'package:rescape_web/ui/view/bloc/view_page_controller.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  final _pageController = PageController(initialPage: UserData.isAdmin ? 0 : 1);

  late StreamSubscription _pageSubscription;

  bool _loaded = UserData.isAdmin;

  String? _error;

  @override
  void initState() {
    super.initState();
    ViewPageController.init();
    PopupController.init();
    _pageSubscription = ViewPageController.stream.listen((page) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
      ViewPageController.setCurrentIndex(page);
    });
    CartItemsNumberController.init();
    if (!UserData.isAdmin)
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        try {
          final discountedProductsDecoded =
              await CompaniesAPI.getDiscounts(UserData.instance.companyId!);
          if (discountedProductsDecoded['error'])
            throw Exception(discountedProductsDecoded['message']);
          else {
            final discountDecoded =
                await CompaniesAPI.getDiscount(UserData.instance.companyId!);

            if (discountDecoded['error'])
              throw Exception(discountDecoded['message']);

            UserData.instance.discount = discountDecoded['discount'];

            DiscountedData.setInstance([
              for (var discountedItem in discountedProductsDecoded['discounts'])
                DiscountedModel(
                  productId: discountedItem['productId'],
                  discount: discountedItem['discount'],
                ),
            ]);
            setState(() => _loaded = true);
          }
        } catch (e) {
          setState(() => _error = e.toString());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loaded
          ? LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Column(
                    children: [
                      if (constraints.maxWidth < 896)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => MobileNavigation(),
                                ),
                                icon: Icon(Icons.menu),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Rescape',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Row(
                          children: [
                            if (constraints.maxWidth > 896) CustomSidebar(),
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: UserData.isAdmin
                                    ? [
                                        OrdersPage(),
                                        ProductListPage(),
                                        CompaniesPage(),
                                        DiscountsPage(),
                                        FinancesPage(),
                                        SpecialsPage(),
                                      ]
                                    : [
                                        CartPage(),
                                        CustomerProductsListPage(),
                                        CustomerOrdersPage(),
                                        CustomerDiscountsPage(),
                                        CustomerFinancesPage(),
                                        CustomerSpecialsPage(),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: PopupController.stream,
                    builder: (context, AsyncSnapshot popup) =>
                        popup.data != null
                            ? AnimatedPopup(child: popup.data)
                            : const SizedBox(),
                  ),
                ],
              ),
            )
          : Center(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _error!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    if (UserData.isAdmin) CartItemsNumberController.dispose();
    _pageController.dispose();
    _pageSubscription.cancel();
    ViewPageController.dispose();
    PopupController.dispose();
    super.dispose();
  }
}
