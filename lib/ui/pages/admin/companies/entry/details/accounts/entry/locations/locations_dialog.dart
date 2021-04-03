import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/company_account_model.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/accounts/entry/locations/entry.dart';

class LocationsDialog extends StatefulWidget {
  final CompanyModel company;
  final CompanyAccountModel account;

  LocationsDialog({required this.company, required this.account});

  @override
  State<StatefulWidget> createState() {
    return _LocationsDialogState();
  }
}

class _LocationsDialogState extends State<LocationsDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 1.7,
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.account.username} · Lokacije',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: ListView(
                      children: [
                        for (var location in widget.company.locations)
                          LocationsDialogOption(
                            account: widget.account,
                            location: location!,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
