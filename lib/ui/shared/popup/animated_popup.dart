import 'package:flutter/material.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AnimatedPopup extends StatefulWidget {
  final Widget child;

  AnimatedPopup({required this.child});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedPopupState();
  }
}

class _AnimatedPopupState extends State<AnimatedPopup> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => setState(() => _visible = true));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white70),
              child: SizedBox.expand(),
            ),
            onTap: () {
              if (_visible) setState(() => _visible = false);
              Future.delayed(
                const Duration(milliseconds: 250),
                () => PopupController.hide(),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}
