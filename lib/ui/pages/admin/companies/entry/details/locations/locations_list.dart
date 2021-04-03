import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/locations/add_location_popup.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/locations/location_entry.dart';

class CompanyLocationsList extends StatefulWidget {
  final CompanyModel company;

  CompanyLocationsList({required this.company});

  @override
  State<StatefulWidget> createState() {
    return _CompanyLocationsListState();
  }
}

class _CompanyLocationsListState extends State<CompanyLocationsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 14),
          child: Text(
            'Lokacije',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              InkWell(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
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
                          'Dodaj lokaciju',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  final bool? added = await showDialog(
                    context: context,
                    barrierColor: Colors.white70,
                    builder: (context) => AddLocationPopup(
                      company: widget.company,
                    ),
                  );

                  if (added != null) setState(() {});
                },
              ),
              for (var location in widget.company.locations)
                LocationEntry(
                  company: widget.company,
                  location: location!,
                  rebuildParent: () => setState(() {}),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
