import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/specials.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AddSpecialDialog extends StatefulWidget {
  final Function rebuildParent;

  AddSpecialDialog({required this.rebuildParent});

  @override
  State<StatefulWidget> createState() {
    return _AddSpecialDialogState();
  }
}

class _AddSpecialDialogState extends State<AddSpecialDialog> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Map?> _images = [null, null];

  String? _error;

  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: const [BoxShadow(blurRadius: 8)],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      'Akcijska Ponuda',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(hintText: 'PROMO KOD'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 10),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Unesite tekst',
                    ),
                    maxLines: 3,
                    minLines: 3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 2; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: IconButton(
                          icon: _images[i] != null
                              ? Image.memory(
                                  base64Decode(_images[i]!['imageBytes']))
                              : Icon(
                                  i == 0
                                      ? Icons.desktop_mac
                                      : Icons.phone_android,
                                  color: Colors.white,
                                ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null)
                              setState(() => _images[i] = {
                                    'platform': i == 0 ? 'desktop' : 'mobile',
                                    'imageBytes':
                                        base64Encode(result.files.first.bytes!)
                                  });
                          },
                        ),
                      ),
                  ],
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
                  padding: const EdgeInsets.only(top: 20),
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
                            if (_descriptionController.text.isNotEmpty &&
                                _images.where((e) => e != null).isNotEmpty) {
                              try {
                                _images.removeWhere((e) => e == null);
                                final response = await SpecialsAPI.create(
                                    _codeController.text.toUpperCase(),
                                    _descriptionController.text,
                                    [for (var image in _images) image!]);
                                if (response['error'])
                                  setState(() {
                                    _uploading = false;
                                    _error = response['message'];
                                  });
                                else {
                                  PopupController.hide();
                                  widget.rebuildParent();
                                }
                              } catch (e) {
                                setState(() {
                                  _uploading = false;
                                  _error = '$e';
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
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
