import 'package:flutter/material.dart';
import 'package:rescape_web/ui/pages/admin/companies/add_company_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AddCompanyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 70,
      bottom: 30,
      child: InkWell(
        customBorder: CircleBorder(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).accentColor,
                blurRadius: 12,
              ),
            ],
          ),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Icon(
                Icons.add,
                size: 56,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap: () => PopupController.show(AddCompanyPopup()),
      ),
    );
  }
}
