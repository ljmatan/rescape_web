import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/ui/pages/admin/companies/companies_page.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AddCompanyPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddCompanyPopupState();
  }
}

class _AddCompanyPopupState extends State<AddCompanyPopup> {
  final _nameController = TextEditingController();
  final _pibController = TextEditingController();

  bool _uploading = false;

  String? _error;

  Uint8List? _photo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor,
          boxShadow: const [BoxShadow(blurRadius: 6)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 40),
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
                TextField(
                  autofocus: true,
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Naziv Kompanije',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pibController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Porezni Identifikacijski Broj',
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
                    onTap: () async {
                      if (_nameController.text.isNotEmpty &&
                          _pibController.text.isNotEmpty &&
                          int.tryParse(_pibController.text) != null) {
                        final Map body = {
                          'name': _nameController.text,
                          'pib': int.parse(_pibController.text),
                          'locations': [],
                          'discounts': [],
                          if (_photo != null) 'photo': base64Encode(_photo!),
                        };

                        try {
                          final Map decoded = await CompaniesAPI.addNew(body);
                          if (decoded['error'])
                            setState(() {
                              _error = decoded['message'];
                              _uploading = false;
                            });
                          else {
                            CompaniesPage.state.refresh();
                            PopupController.hide();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Kompanija uspešno dodana.')));
                          }
                        } catch (e) {
                          setState(() {
                            _error = '$e';
                            _uploading = false;
                          });
                        }
                      } else
                        setState(
                            () => _error = 'Molimo proverite unesene podatke.');
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
    _nameController.dispose();
    _pibController.dispose();
    super.dispose();
  }
}
