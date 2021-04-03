import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';

class AddAccountPopup extends StatefulWidget {
  final CompanyModel company;

  AddAccountPopup({required this.company});

  @override
  State<StatefulWidget> createState() {
    return _AddAccountPopupState();
  }
}

class _AddAccountPopupState extends State<AddAccountPopup> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController(
      text: (100000 + Random().nextInt(900000)).toString());

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
                    'Dodaj Nalog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Korisničko Ime',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Lozinka',
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
                          _passwordController.text.isNotEmpty) {
                        try {
                          final decoded = await CompaniesAPI.addAccount({
                            'username': _nameController.text,
                            'password': _passwordController.text,
                            'companyId': widget.company.id,
                            'type': 'customer',
                            'locations': [],
                          });
                          if (decoded['error'])
                            setState(() {
                              _error = decoded['message'];
                              _uploading = false;
                            });
                          else {
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Račun uspešno dodan.')));
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
    _passwordController.dispose();
    super.dispose();
  }
}
