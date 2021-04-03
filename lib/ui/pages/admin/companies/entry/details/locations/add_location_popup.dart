import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';

class AddLocationPopup extends StatefulWidget {
  final CompanyModel company;

  AddLocationPopup({required this.company});

  @override
  State<StatefulWidget> createState() {
    return _AddLocationPopupState();
  }
}

class _AddLocationPopupState extends State<AddLocationPopup> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationNumberController = TextEditingController();

  bool _uploading = false;

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 30),
                  child: Text(
                    'Dodaj Lokaciju',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _addressController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ulica i broj',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  controller: _cityController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Grad',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationNumberController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Broj lokacije',
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
                      if (_addressController.text.isNotEmpty &&
                          _cityController.text.isNotEmpty &&
                          _locationNumberController.text.isNotEmpty &&
                          int.tryParse(_locationNumberController.text) !=
                              null) {
                        try {
                          final decoded = await CompaniesAPI.addLocation(
                              widget.company.id, {
                            'street': _addressController.text,
                            'city': _cityController.text,
                            'locationNumber':
                                int.parse(_locationNumberController.text),
                          });
                          if (decoded['error'])
                            setState(() {
                              _error = decoded['message'];
                              _uploading = false;
                            });
                          else {
                            widget.company.locations.add(
                              LocationModel(
                                street: _addressController.text,
                                city: _cityController.text,
                                locationNumber:
                                    int.parse(_locationNumberController.text),
                              ),
                            );
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Lokacija uspešno dodana.')));
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
    _addressController.dispose();
    _locationNumberController.dispose();
    super.dispose();
  }
}
