import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/companies_page.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/company_details_screen.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class DiscountsListCompanyEntry extends StatefulWidget {
  final CompanyModel company;
  final Function refreshParent;
  final BoxConstraints constraints;

  DiscountsListCompanyEntry({
    required this.company,
    required this.refreshParent,
    required this.constraints,
  });

  @override
  State<StatefulWidget> createState() {
    return _DiscountsListCompanyEntryState();
  }
}

class _DiscountsListCompanyEntryState extends State<DiscountsListCompanyEntry> {
  bool _isHovered = false;

  Future _delete() async => await CompaniesAPI.delete(widget.company.id)
      .whenComplete(() => CompaniesPage.state.refresh());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.company.photo == null ? Colors.black26 : null,
                borderRadius: BorderRadius.circular(40),
                image: widget.company.photo == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(widget.company.photo!),
                      ),
                boxShadow: kElevationToShadow[1],
              ),
              child: AnimatedOpacity(
                opacity: _isHovered ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.red[300],
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.white70,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              try {
                                final response = await CompaniesAPI.updatePhoto(
                                    widget.company.id,
                                    base64Encode(result.files.first.bytes!));
                                Navigator.pop(context);
                                if (response['error'] == true)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response['message'])));
                                else
                                  CompaniesPage.state.refresh();
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$e')));
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red[300],
                          ),
                          onPressed: () => PopupController.show(
                            ConfirmDeletionPopup(future: _delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
              child: Text(
                widget.company.name +
                    '\n' +
                    widget.company.discount.toString() +
                    '% popusta',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      onHover: (isHovered) => setState(() => _isHovered = isHovered),
      onTap: widget.constraints.maxWidth > 896
          ? () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CompanyDetailsScreen(
                    company: widget.company,
                  ),
                ),
              );
              widget.refreshParent();
            }
          : null,
    );
  }
}
