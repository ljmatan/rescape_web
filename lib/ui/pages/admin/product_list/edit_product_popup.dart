import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/discounts/discounts_page.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_page.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class EditProductPopup extends StatefulWidget {
  final ProductModel product;

  EditProductPopup({required this.product});

  @override
  State<StatefulWidget> createState() {
    return _EditProductPopupState();
  }
}

class _EditProductPopupState extends State<EditProductPopup> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _labels = const ['CENA', 'PDV', 'POPUST'];

  late List<TextEditingController> _textControllers;

  Uint8List? _photo;

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
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[16],
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    Positioned(
                      left: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          iconSize: 64,
                          icon: _photo == null
                              ? Icon(Icons.add_photo_alternate,
                                  color: Colors.white)
                              : Image.memory(_photo!),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null)
                              setState(() => _photo = result.files.first.bytes);
                          },
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
                                    padding: const EdgeInsets.only(right: 16),
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
                                      if (double.tryParse(input) == null ||
                                          double.parse(input) < 0 ||
                                          i == 1 && double.parse(input) > 100)
                                        return 'Please check your input';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: i != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Text(
                                                '%',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                final response = await ProductsAPI.update({
                                  'id': widget.product.id,
                                  if (double.tryParse(
                                          _textControllers[0].text) !=
                                      null)
                                    'price':
                                        double.parse(_textControllers[0].text),
                                  if (double.tryParse(
                                          _textControllers[1].text) !=
                                      null)
                                    'vat':
                                        double.parse(_textControllers[1].text),
                                  if (double.tryParse(
                                          _textControllers[2].text) !=
                                      null)
                                    'discount':
                                        double.parse(_textControllers[2].text),
                                  if (_photo != null)
                                    'photo': base64Encode(_photo!),
                                });
                                if (response['error'] != false)
                                  setState(() {
                                    _error = response['message'];
                                    _uploading = false;
                                  });
                                else {
                                  PopupController.hide();
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
    );
  }

  @override
  void dispose() {
    for (var controller in _textControllers) controller.dispose();
    super.dispose();
  }
}
