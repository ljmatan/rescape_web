import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/specials_model.dart';
import 'package:rescape_web/logic/api/specials.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class SpecialsEntry extends StatefulWidget {
  final SpecialsModel special;
  final Function rebuildParent;

  SpecialsEntry({required this.special, required this.rebuildParent});

  @override
  State<StatefulWidget> createState() {
    return _SpecialsEntryState();
  }
}

class _SpecialsEntryState extends State<SpecialsEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.special.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => PopupController.show(
                      ConfirmDeletionPopup(
                        future: () async => await SpecialsAPI.delete(
                          widget.special.id,
                        ).whenComplete(() => widget.rebuildParent()),
                      ),
                    ),
                    icon: Icon(Icons.close),
                    color: Colors.red.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
