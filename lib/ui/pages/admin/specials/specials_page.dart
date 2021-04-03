import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/specials_model.dart';
import 'package:rescape_web/logic/api/specials.dart';
import 'package:rescape_web/ui/pages/admin/specials/add_special_dialog.dart';
import 'package:rescape_web/ui/pages/admin/specials/entry.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class SpecialsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SpecialsPageState();
  }
}

class _SpecialsPageState extends State<SpecialsPage> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          FutureBuilder(
            future: SpecialsAPI.getAll(),
            builder: (context, AsyncSnapshot<List<SpecialsModel>> specials) =>
                specials.connectionState != ConnectionState.done ||
                        specials.hasError ||
                        specials.hasData && specials.data!.isEmpty
                    ? Center(
                        child: specials.connectionState != ConnectionState.done
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  specials.hasError
                                      ? specials.error.toString()
                                      : 'Nema akcijskih ponuda.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          for (var special in specials.data!)
                            SpecialsEntry(
                              special: special,
                              rebuildParent: refresh,
                            ),
                        ],
                      ),
          ),
          if (constraints.maxWidth > 896)
            Positioned(
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
                onTap: () => PopupController.show(
                  AddSpecialDialog(rebuildParent: refresh),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
