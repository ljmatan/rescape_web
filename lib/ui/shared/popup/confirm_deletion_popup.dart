import 'package:flutter/material.dart';
import 'package:rescape_web/ui/shared/spinning_indicator.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class ConfirmDeletionPopup extends StatefulWidget {
  final Function future;
  final bool pop;

  ConfirmDeletionPopup({required this.future, this.pop = false});

  @override
  State<StatefulWidget> createState() {
    return _ConfirmDeletionPopupState();
  }
}

class _ConfirmDeletionPopupState extends State<ConfirmDeletionPopup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: const [BoxShadow(blurRadius: 8)],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: const EdgeInsets.only(bottom: 26),
                child: Text(
                  'Obrisati ovu stavku?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Text('Da'),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.white70,
                          builder: (context) => CustomSpinningIndicator());
                      var decoded;
                      try {
                        decoded = await widget.future();
                      } catch (e) {
                        print('$e');
                      }
                      Navigator.pop(context);
                      PopupController.hide();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(decoded == null
                              ? 'Greška. Molimo pokušajte kasnije'
                              : decoded['error']
                                  ? decoded['message']
                                  : 'Stavka obrisana')));
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    child: Text('Ne'),
                    onPressed: () => widget.pop
                        ? Navigator.pop(context)
                        : PopupController.hide(),
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
