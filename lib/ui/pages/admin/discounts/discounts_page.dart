import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/admin/discounts/entries/discounts_list_company_entry.dart';
import 'package:rescape_web/ui/pages/admin/discounts/entries/discounts_list_product_entry.dart';
import 'bloc/selected_filter_controller.dart';
import 'nav_menu_button.dart';

class DiscountsPage extends StatefulWidget {
  static late _DiscountsPageState? state;

  @override
  State<StatefulWidget> createState() {
    state = _DiscountsPageState();
    return state!;
  }
}

class _DiscountsPageState extends State<DiscountsPage> {
  void refresh() {
    if (mounted) setState(() {});
  }

  Future _getDiscounts(String filter) async =>
      await jsonDecode((await HTTPHelper.get('/$filter/discounts')).body);

  @override
  void initState() {
    super.initState();
    SelectedFilterController.init();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth > 896 ? 16 : 0),
            child: Row(
              children: [
                NavMenuButton(
                  label: 'Proizvodi',
                  filter: 'products',
                ),
                NavMenuButton(
                  label: 'Kompanije',
                  filter: 'companies',
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: SelectedFilterController.stream,
              initialData: 'products',
              builder: (context, AsyncSnapshot filter) => FutureBuilder(
                future: _getDiscounts(filter.data),
                builder: (context, AsyncSnapshot discounts) => discounts
                                .connectionState !=
                            ConnectionState.done ||
                        discounts.hasError ||
                        discounts.hasData &&
                            discounts.data!['discounts']?.isEmpty ||
                        discounts.hasData && discounts.data['error'] == true
                    ? Center(
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
                      )
                    : GridView.builder(
                        padding: constraints.maxWidth > 896
                            ? const EdgeInsets.fromLTRB(50, 60, 50, 60)
                            : const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 896 ? 7 : 2,
                          crossAxisSpacing:
                              constraints.maxWidth > 896 ? 40 : 12,
                          mainAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                          childAspectRatio: constraints.maxWidth > 896
                              ? (MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.width + 520))
                              : (MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.width + 60)),
                        ),
                        itemCount: discounts.data['discounts'].length,
                        itemBuilder: (context, i) => filter.data == 'products'
                            ? DiscountsProductEntry(
                                product: ProductModel.fromMap(
                                  discounts.data['discounts'][i],
                                ),
                                constraints: constraints,
                              )
                            : DiscountsListCompanyEntry(
                                company: CompanyModel.fromMap(
                                  discounts.data['discounts'][i],
                                ),
                                refreshParent: refresh,
                                constraints: constraints,
                              ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SelectedFilterController.dispose();
    super.dispose();
  }
}
