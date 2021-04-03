import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';

class LocationEntry extends StatefulWidget {
  final CompanyModel company;
  final LocationModel location;
  final Function rebuildParent;

  LocationEntry({
    required this.company,
    required this.location,
    required this.rebuildParent,
  });

  @override
  State<StatefulWidget> createState() {
    return _LocationEntryState();
  }
}

class _LocationEntryState extends State<LocationEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(blurRadius: 4)],
          ),
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 0 : 1,
                        child: Text(
                          '${widget.location.street}, ${widget.location.city}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 1 : 0,
                        child: Icon(
                          Icons.close,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () => showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white70,
          builder: (context) => ConfirmDeletionPopup(
            future: () async => await CompaniesAPI.deleteLocation(
              widget.company.id,
              widget.location.locationNumber,
            ).then(
              (decoded) {
                Navigator.pop(context);
                if (!decoded['error']) {
                  widget.company.locations.removeWhere((e) =>
                      e!.locationNumber == widget.location.locationNumber);
                  widget.rebuildParent();
                }
              },
            ),
            pop: true,
          ),
        ),
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
      ),
    );
  }
}
