import 'package:flutter/material.dart';
import 'package:rescape_web/data/products/products.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/accounts/accounts_list.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/locations/locations_list.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/products/company_product_entry.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final CompanyModel company;

  CompanyDetailsScreen({required this.company});

  @override
  State<StatefulWidget> createState() {
    return _CompanyDetailsScreenState();
  }
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  Future<List<ProductModel>> _getProducts() async {
    if (ProductsData.instance == null) await ProductsAPI.getAll();

    return ProductsData.instance!;
  }

  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _discountController =
        TextEditingController(text: widget.company.discount?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.company.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          CompanyLocationsList(company: widget.company),
          CompanyAccountsList(company: widget.company),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 34, 0, 12),
            child: Text(
              'Popusti',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Generalni popust:    '),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _discountController,
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    buildCounter: (
                      BuildContext context, {
                      int? currentLength,
                      int? maxLength,
                      bool? isFocused,
                    }) =>
                        null,
                  ),
                ),
                Text('    %    '),
                TextButton(
                  child: Text('POTVRDI'),
                  onPressed: () async {
                    if (_discountController.text.isNotEmpty &&
                        double.tryParse(_discountController.text) != null &&
                        double.parse(_discountController.text) > 0 &&
                        double.parse(_discountController.text) <= 100) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.white70,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      try {
                        final response = await CompaniesAPI.updateDiscount(
                            widget.company.id,
                            double.parse(_discountController.text));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'])));
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('$e')));
                      }
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Molimo proverite unesene podatke')));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 34),
            child: Text(
              'Popusti na proizvode',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          FutureBuilder(
            future: _getProducts(),
            builder: (context, products) => LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 18),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 896 ? 10 : 2,
                  crossAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                  mainAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                  childAspectRatio: constraints.maxWidth > 896
                      ? (MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.width + 572))
                      : (MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.width + 60)),
                ),
                itemCount: ProductsData.instance!.length,
                itemBuilder: (context, i) => CompanyDetailsProductEntry(
                  company: widget.company,
                  product: ProductsData.instance![i],
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
    _discountController.dispose();
    super.dispose();
  }
}
