import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/customer/product_list/product_entry.dart';

class CustomerProductsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerProductsListPageState();
  }
}

class _CustomerProductsListPageState extends State<CustomerProductsListPage> {
  String? _filter;

  List<ProductModel>? _products;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _products == null
          ? ProductsAPI.getAll().then((value) {
              _products = value;
              return value;
            })
          : Future(() {
              List returnValue = List.from(_products!);
              if (_filter != null)
                returnValue.removeWhere((e) => e.category != _filter);
              return returnValue;
            }),
      builder: (context, AsyncSnapshot products) => products.connectionState !=
                  ConnectionState.done ||
              products.hasError ||
              products.hasData && products.data!.isEmpty
          ? Center(
              child: products.connectionState != ConnectionState.done
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        products.hasError
                            ? products.error.toString()
                            : 'Nema dodanih proizvoda',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: constraints.maxWidth > 896 ? 80 : 64,
                    child: ListView(
                      padding: constraints.maxWidth > 896
                          ? const EdgeInsets.only(left: 50, right: 30)
                          : const EdgeInsets.only(left: 16, right: 4),
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var category in Set.from([
                          for (var product in (_products ?? products.data))
                            product.category
                        ]))
                          Padding(
                            padding: constraints.maxWidth > 896
                                ? const EdgeInsets.only(top: 30, right: 16)
                                : const EdgeInsets.only(top: 16, right: 12),
                            child: InkWell(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _filter == category
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 16, 30, 16),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: _filter == category
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => setState(
                                () => _filter =
                                    (_filter == category ? null : category),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: products.data.length,
                    itemBuilder: (context, i) => CustomerProductListEntry(
                      product: products.data[i],
                      constraints: constraints,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
