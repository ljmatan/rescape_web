import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/discounts/discounts_page.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_page.dart';

class EditProductDialog extends StatefulWidget {
  final ProductModel product;

  EditProductDialog({required this.product});

  @override
  State<StatefulWidget> createState() {
    return _EditProductDialogState();
  }
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _labels = const ['CENA', 'PDV', 'POPUST'];

  late List<TextEditingController> _textControllers;

  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _textControllers = [
      TextEditingController(
        text: widget.product.price.toString(),
      ),
      TextEditingController(
        text: widget.product.vat.toString(),
      ),
      TextEditingController(
        text: widget.product.discount?.toString() ?? '',
      ),
    ];
  }

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text(
                                  'Uredi Proizvod',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              for (var i = 0; i < _textControllers.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16),
                                            child: Text(
                                              _labels[i],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _textControllers[i],
                                          validator: (input) {
                                            if (input!.isNotEmpty) {
                                              if (double.tryParse(input) ==
                                                      null ||
                                                  double.parse(input) < 0 ||
                                                  i == 1 &&
                                                      double.parse(input) > 100)
                                                return 'Please check your input';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              suffixIcon: i != 0
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                      ),
                                                      child: Text(
                                                        '%',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    )
                                                  : null),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _error!,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                                          'IZMENI',
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
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _uploading = true);
                                      try {
                                        final response =
                                            await ProductsAPI.update({
                                          'id': widget.product.id,
                                          if (double.tryParse(
                                                  _textControllers[0].text) !=
                                              null)
                                            'price': double.parse(
                                                _textControllers[0].text),
                                          if (double.tryParse(
                                                  _textControllers[1].text) !=
                                              null)
                                            'vat': double.parse(
                                                _textControllers[1].text),
                                          if (double.tryParse(
                                                  _textControllers[2].text) !=
                                              null)
                                            'discount': double.parse(
                                                _textControllers[2].text),
                                        });
                                        if (response['error'] != false)
                                          setState(() {
                                            _error = response['message'];
                                            _uploading = false;
                                          });
                                        else {
                                          Navigator.pop(context);
                                          ProductListPage.state?.refresh();
                                          DiscountsPage.state?.refresh();
                                        }
                                      } catch (e) {
                                        print('$e');
                                        setState(() {
                                          _error = '$e';
                                          _uploading = false;
                                        });
                                      }
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _textControllers) controller.dispose();
    super.dispose();
  }
}
