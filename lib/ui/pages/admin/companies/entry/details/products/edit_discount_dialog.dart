import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/item_discounts.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/discounted_model.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';

class EditCompanyProductDiscountDialog extends StatefulWidget {
  final CompanyModel company;
  final ProductModel product;

  EditCompanyProductDiscountDialog({
    required this.company,
    required this.product,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditCompanyProductDiscountDialogState();
  }
}

class _EditCompanyProductDiscountDialogState
    extends State<EditCompanyProductDiscountDialog> {
  late TextEditingController _discountController;

  double? _discount;

  @override
  void initState() {
    super.initState();
    if (widget.company.discounts
        .where((e) => e.productId == widget.product.id)
        .isNotEmpty)
      _discount = widget.company.discounts
          .firstWhere((e) => e.productId == widget.product.id)
          .discount;
    _discountController =
        TextEditingController(text: _discount?.toString() ?? '');
  }

  bool _uploading = false;

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 16,
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Text(
                    'Uredi Popust',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextField(
                  controller: _discountController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Unesite procenat popusta',
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: InkWell(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: SizedBox(
                        width: 150,
                        height: 56,
                        child: Center(
                          child: _uploading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  'DODAJ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    onTap: _uploading
                        ? null
                        : () async {
                            if (_discountController.text.isNotEmpty &&
                                double.tryParse(_discountController.text) !=
                                    null &&
                                double.parse(_discountController.text) >= 0 &&
                                double.parse(_discountController.text) <= 100) {
                              setState(() => _uploading = true);
                              try {
                                final decoded =
                                    await ItemDiscountsAPI.editDiscount(
                                  widget.company.id,
                                  widget.product.id,
                                  double.parse(_discountController.text),
                                );
                                if (decoded['error'])
                                  setState(() {
                                    _uploading = false;
                                    _error = decoded['message'];
                                  });
                                else {
                                  Navigator.pop(context);
                                  if (_discount != null &&
                                      _discountController.text == '0')
                                    widget.company.discounts.removeWhere((e) =>
                                        e.productId == widget.product.id);
                                  else {
                                    if (_discount != null)
                                      widget.company.discounts
                                              .firstWhere(
                                                  (e) =>
                                                      e.productId ==
                                                      widget.product.id)
                                              .discount =
                                          double.parse(
                                              _discountController.text);
                                    else
                                      widget.company.discounts.add(
                                          DiscountedModel(
                                              productId: widget.product.id,
                                              discount: double.parse(
                                                  _discountController.text)));
                                  }
                                }
                              } catch (e) {
                                setState(() {
                                  _uploading = false;
                                  _error = e.toString();
                                });
                              }
                            } else
                              setState(() => _error = 'Molimo proverite info.');
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }
}
