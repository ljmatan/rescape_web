import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_account_model.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/accounts/entry/locations/locations_dialog.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';

class AccountEntry extends StatefulWidget {
  final CompanyModel company;
  final CompanyAccountModel account;

  AccountEntry({required this.company, required this.account});

  @override
  State<StatefulWidget> createState() {
    return _AccountEntryState();
  }
}

class _AccountEntryState extends State<AccountEntry> {
  bool _isHovered = false;

  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _deleted ? Colors.red.shade300 : Colors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(blurRadius: 4)],
          ),
          child: Stack(
            children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 0 : 1,
                        child: Text(
                          '${widget.account.username}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1 : 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _deleted
                              ? null
                              : () => showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.white70,
                                    builder: (context) => LocationsDialog(
                                      company: widget.company,
                                      account: widget.account,
                                    ),
                                  ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade300,
                          ),
                          onPressed: _deleted
                              ? null
                              : () => showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.white70,
                                    builder: (context) => ConfirmDeletionPopup(
                                      future: () async =>
                                          await CompaniesAPI.removeAccount(
                                        widget.account.id,
                                      ).then(
                                        (value) {
                                          Navigator.pop(context);
                                          if (!value['error'])
                                            setState(() => _deleted = true);
                                          return value;
                                        },
                                      ),
                                      pop: true,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: _deleted ? null : () {},
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
      ),
    );
  }
}
