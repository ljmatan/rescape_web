import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/other/measures.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_page.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class MeasureSelectionOption extends StatelessWidget {
  final StreamController measureController;
  final Measure type;
  final String label;

  MeasureSelectionOption({
    required this.measureController,
    required this.type,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: measureController.stream,
        initialData: Measure.kg,
        builder: (context, selected) => InkWell(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: selected.data == type
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected.data == type
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onTap: () => measureController.add(type),
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProductDialogState();
  }
}

class _AddProductDialogState extends State<AddProductDialog> {
  final Set<String> _labels = {
    'INTERNI KOD',
    'NAZIV',
    'BARKOD',
    'KATEGORIJA',
    'CENA BEZ PDV',
    'PDV PROCENAT',
  };

  final _internalCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _vatController = TextEditingController(text: '20');
  final _inPackageController = TextEditingController();

  late List<TextEditingController> _textControllers;

  final _measureTypeController = StreamController.broadcast();

  Measure _measureType = Measure.kg;
  String _measure = 'KG';

  late StreamSubscription _measureSubscription;

  @override
  void initState() {
    super.initState();
    _textControllers = [
      _internalCodeController,
      _nameController,
      _barcodeController,
      _categoryController,
      _priceController,
      _vatController,
    ];
    _measureSubscription = _measureTypeController.stream.listen((type) {
      _measure = type == Measure.qty ? 'QTY' : _measure = 'KG';
      _measureType = type;
    });
  }

  bool _uploading = false;

  String? _error;

  Uint8List? _photo;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor,
          boxShadow: const [BoxShadow(blurRadius: 6)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 20),
                  child: IconButton(
                    iconSize: 64,
                    icon: _photo == null
                        ? Icon(Icons.add_photo_alternate, color: Colors.white)
                        : Image.memory(_photo!),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null)
                        setState(() => _photo = result.files.first.bytes);
                    },
                  ),
                ),
                for (var i = 0; i < 6; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                _labels.elementAt(i),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            autofocus: i == 0,
                            controller: _textControllers[i],
                            decoration: InputDecoration(
                              suffixIcon: i == 5
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            'MERA',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          MeasureSelectionOption(
                            measureController: _measureTypeController,
                            type: Measure.kg,
                            label: 'KG',
                          ),
                          const SizedBox(width: 8),
                          MeasureSelectionOption(
                            measureController: _measureTypeController,
                            type: Measure.qty,
                            label: 'KOM',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: StreamBuilder(
                              stream: _measureTypeController.stream,
                              initialData: Measure.kg,
                              builder: (context, selected) => Text(
                                selected.data == Measure.kg
                                    ? 'U PAKETU'
                                    : 'U KUTIJI',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _inPackageController,
                        ),
                      ),
                    ],
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
                            if (_internalCodeController.text.isNotEmpty &&
                                int.tryParse(_internalCodeController.text) !=
                                    null &&
                                int.parse(_internalCodeController.text) >= 0 &&
                                _internalCodeController.text.length == 3 &&
                                (_barcodeController.text.isEmpty ||
                                    int.tryParse(_barcodeController.text) !=
                                        null) &&
                                _nameController.text.isNotEmpty &&
                                _categoryController.text.isNotEmpty &&
                                _priceController.text.isNotEmpty &&
                                double.tryParse(_priceController.text) !=
                                    null &&
                                double.parse(_priceController.text) > 0 &&
                                _vatController.text.isNotEmpty &&
                                int.tryParse(_vatController.text) != null &&
                                int.parse(_vatController.text) <= 100 &&
                                int.parse(_vatController.text) >= 0 &&
                                (_measureType == Measure.kg
                                    ? (_inPackageController.text.isEmpty ||
                                        _inPackageController.text.isNotEmpty &&
                                            double.tryParse(_inPackageController
                                                    .text) !=
                                                null)
                                    : (_inPackageController.text.isEmpty ||
                                        _inPackageController.text.isNotEmpty &&
                                            int.tryParse(_inPackageController
                                                    .text) !=
                                                null))) {
                              setState(() => _uploading = true);

                              final Map body = {
                                'internalCode': _internalCodeController.text,
                                'name': _nameController.text,
                                if (_barcodeController.text.isNotEmpty)
                                  'barcode': int.parse(_barcodeController.text),
                                'category': _categoryController.text,
                                'price': double.parse(_priceController.text),
                                'vat': int.parse(_vatController.text),
                                'measure': _measure,
                                if (_inPackageController.text.isNotEmpty)
                                  'inPackage': _measureType == Measure.kg
                                      ? double.parse(_inPackageController.text)
                                      : int.parse(_inPackageController.text),
                                if (_photo != null)
                                  'photo': base64Encode(_photo!),
                              };

                              try {
                                final Map decoded =
                                    await ProductsAPI.addNew(body);
                                if (decoded['error'])
                                  setState(() {
                                    _error = decoded['message'];
                                    _uploading = false;
                                  });
                                else {
                                  ProductListPage.state?.refresh();
                                  PopupController.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Proizvod uspešno dodan.')));
                                }
                              } catch (e) {
                                setState(() {
                                  _error = '$e';
                                  _uploading = false;
                                });
                              }
                            } else
                              setState(() =>
                                  _error = 'Molimo proverite unesene podatke.');
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
    _measureTypeController.close();
    _measureSubscription.cancel();
    for (var controller in _textControllers) controller.dispose();
    super.dispose();
  }
}
