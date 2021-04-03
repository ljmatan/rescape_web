import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_account_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';

class LocationsDialogOption extends StatefulWidget {
  final CompanyAccountModel account;
  final LocationModel location;

  LocationsDialogOption({required this.account, required this.location});

  @override
  State<StatefulWidget> createState() {
    return _LocationsDialogOptionState();
  }
}

class _LocationsDialogOptionState extends State<LocationsDialogOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.location.street}, ${widget.location.city}'),
            Checkbox(
              value: widget.account.locations.firstWhere(
                      (e) =>
                          e!.locationNumber == widget.location.locationNumber,
                      orElse: () => null) !=
                  null,
              onChanged: (value) async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.white70,
                  builder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                try {
                  final decoded = value!
                      ? await CompaniesAPI.addAccountLocation(
                          widget.account.id, widget.location.locationNumber)
                      : await CompaniesAPI.removeAccountLocation(
                          widget.account.id, widget.location.locationNumber);
                  if (decoded['error']) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(decoded['message'])));
                  } else {
                    value
                        ? widget.account.locations.add(LocationModel(
                            street: widget.location.street,
                            city: widget.location.city,
                            locationNumber: widget.location.locationNumber))
                        : widget.account.locations.removeWhere(
                            (e) =>
                                e!.locationNumber ==
                                widget.location.locationNumber,
                          );
                    Navigator.pop(context);
                    setState(() {});
                  }
                } catch (e) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$e')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
