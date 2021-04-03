import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/ui/pages/admin/companies/add_company_button.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/company_list_entry.dart';

class CompaniesPage extends StatefulWidget {
  static late _CompaniesPageState state;

  @override
  State<StatefulWidget> createState() {
    state = _CompaniesPageState();
    return state;
  }
}

class _CompaniesPageState extends State<CompaniesPage> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          FutureBuilder(
            future: CompaniesAPI.getAll(),
            builder: (context, AsyncSnapshot companies) =>
                companies.connectionState != ConnectionState.done ||
                        companies.hasError ||
                        companies.hasData && companies.data!.isEmpty
                    ? Center(
                        child: companies.connectionState != ConnectionState.done
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  companies.hasError
                                      ? companies.error.toString()
                                      : 'Nema dodanih kompanija.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                      )
                    : GridView.builder(
                        padding: constraints.maxWidth > 896
                            ? const EdgeInsets.fromLTRB(50, 60, 50, 60)
                            : const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 896 ? 7 : 2,
                          crossAxisSpacing:
                              constraints.maxWidth > 896 ? 40 : 12,
                          mainAxisSpacing: constraints.maxWidth > 896 ? 40 : 12,
                          childAspectRatio: constraints.maxWidth > 896
                              ? (MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.width + 520))
                              : (MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.width + 60)),
                        ),
                        itemCount: companies.data.length,
                        itemBuilder: (context, i) => CompanyListEntry(
                          company: companies.data[i],
                          refreshParent: refresh,
                          constraints: constraints,
                        ),
                      ),
          ),
          if (constraints.maxWidth > 896) AddCompanyButton(),
        ],
      ),
    );
  }
}
