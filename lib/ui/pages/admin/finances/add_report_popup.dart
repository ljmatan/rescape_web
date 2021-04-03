import 'package:flutter/material.dart';
import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/finances.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AddFinanceReportPopup extends StatefulWidget {
  final Function rebuildParent;

  AddFinanceReportPopup({required this.rebuildParent});

  @override
  State<StatefulWidget> createState() {
    return _AddFinanceReportPopupState();
  }
}

class _AddFinanceReportPopupState extends State<AddFinanceReportPopup> {
  final _amountController = TextEditingController();

  String? _companyId, _error;

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
                      'Unos Finansija',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Za unos dugovanja, dodajte minus pre iznosa.',
                    ),
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  value: _companyId,
                  dropdownColor: Theme.of(context).primaryColor,
                  hint: Text(
                    'Izaberite kompaniju',
                    style: const TextStyle(color: Colors.white),
                  ),
                  items: [
                    for (var company in CompaniesData.instance!)
                      DropdownMenuItem(
                        child: Text(
                          company!.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: company.id,
                      ),
                  ],
                  onChanged: (String? value) =>
                      setState(() => _companyId = value),
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
                            if (_amountController.text.isNotEmpty &&
                                double.tryParse(_amountController.text) !=
                                    null &&
                                double.parse(_amountController.text) != 0 &&
                                _companyId != null) {
                              setState(() => _uploading = true);
                              try {
                                final response = await FinancesAPI.create(
                                    _companyId!,
                                    double.parse(_amountController.text));
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
    _amountController.dispose();
    super.dispose();
  }
}
