import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_entry.dart';
import 'add_product_button.dart';

class ProductListPage extends StatefulWidget {
  static late _ProductListPageState? state;

  @override
  State<StatefulWidget> createState() {
    state = _ProductListPageState();
    return state!;
  }
}

class _ProductListPageState extends State<ProductListPage> {
  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          FutureBuilder(
            future: ProductsAPI.getAll(),
            builder: (context, AsyncSnapshot products) =>
                products.connectionState != ConnectionState.done ||
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
                        itemCount: products.data.length,
                        itemBuilder: (context, i) => ProductListEntry(
                          product: products.data[i],
                          constraints: constraints,
                        ),
                      ),
          ),
          if (constraints.maxWidth > 896) AddProductButton(),
        ],
      ),
    );
  }
}
