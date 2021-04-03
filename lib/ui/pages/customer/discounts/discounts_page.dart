import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/discounted_data.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/customer/discounts/entry.dart';

class CustomerDiscountsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerDiscountsPageState();
  }
}

class _CustomerDiscountsPageState extends State<CustomerDiscountsPage> {
  Future _getDiscounts() async =>
      await jsonDecode((await HTTPHelper.get('/products/discounts')).body);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDiscounts(),
      builder: (context, AsyncSnapshot discounts) {
        if (discounts.connectionState != ConnectionState.done ||
            discounts.hasError ||
            discounts.hasData && discounts.data!['discounts']?.isEmpty ||
            discounts.hasData && discounts.data['error'] == true)
          return Center(
            child: discounts.connectionState != ConnectionState.done
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      discounts.hasError
                          ? discounts.error.toString()
                          : 'Nema dodeljenih popusta.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
          );
        {
          final List<ProductModel> discounted = [];

          for (var product in discounts.data['discounts'])
            discounted.add(ProductModel.fromMap(product));

          if (UserData.instance.discount != null)
            discounted
                .removeWhere((e) => e.discount! < UserData.instance.discount!);

          for (var discountedItem in DiscountedData.instance!)
            discounted.removeWhere((e) =>
                e.id == discountedItem.productId &&
                e.discount! < discountedItem.discount);

          return discounted.isEmpty
              ? Center(
                  child: Text(
                    'Nema proizvoda na popustu.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) => GridView.builder(
                    padding: constraints.maxWidth > 896
                        ? const EdgeInsets.fromLTRB(50, 60, 50, 60)
                        : const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 896 ? 7 : 2,
                      crossAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                      mainAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                      childAspectRatio: constraints.maxWidth > 896
                          ? (MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.width + 520))
                          : (MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.width + 60)),
                    ),
                    itemCount: discounted.length,
                    itemBuilder: (context, i) => CustomerDiscountsProductEntry(
                      product: discounted[i],
                      constraints: constraints,
                    ),
                  ),
                );
        }
      },
    );
  }
}
