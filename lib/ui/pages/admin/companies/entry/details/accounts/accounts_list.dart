import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_account_model.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/accounts/entry/account_entry.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/add_account_popup.dart';

class CompanyAccountsList extends StatefulWidget {
  final CompanyModel company;

  CompanyAccountsList({required this.company});

  @override
  State<StatefulWidget> createState() {
    return _CompanyAccountsListState();
  }
}

class _CompanyAccountsListState extends State<CompanyAccountsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 0, 14),
          child: Text(
            'Nalozi',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: FutureBuilder(
            future: CompaniesAPI.getAccounts(widget.company.id),
            builder: (context, AsyncSnapshot accounts) => ListView(
              padding: const EdgeInsets.only(left: 16, right: 4),
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [BoxShadow(blurRadius: 4)],
                    ),
                    child: SizedBox(
                      width: 140,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 48, color: Colors.white),
                          Text(
                            'Dodaj nalog',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    final bool? rebuild = await showDialog(
                      context: context,
                      barrierColor: Colors.white70,
                      builder: (context) => AddAccountPopup(
                        company: widget.company,
                      ),
                    );

                    if (rebuild != null && rebuild) setState(() {});
                  },
                ),
                if (accounts.connectionState != ConnectionState.done ||
                    accounts.hasError ||
                    accounts.hasData && accounts.data!['users'].isEmpty)
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: accounts.connectionState != ConnectionState.done
                            ? CircularProgressIndicator()
                            : Text(
                                accounts.hasError
                                    ? accounts.error.toString()
                                    : '',
                              ),
                      ),
                    ),
                  )
                else
                  for (var account in accounts.data!['users'])
                    AccountEntry(
                      company: widget.company,
                      account: CompanyAccountModel(
                        id: account['_id'],
                        username: account['username'],
                        company: widget.company,
                        locations: [
                          for (var locationNumber in account['locations'])
                            if (widget.company.locations.firstWhere(
                                  (e) => e!.locationNumber == locationNumber,
                                  orElse: () => null,
                                ) !=
                                null)
                              widget.company.locations.firstWhere(
                                (e) => e!.locationNumber == locationNumber,
                              )!,
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
