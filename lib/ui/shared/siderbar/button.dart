import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/ui/view/bloc/view_page_controller.dart';

class SidebarButton extends StatefulWidget {
  final String label;
  final int index;
  final Function? onTap;
  final IconData? icon;

  SidebarButton({
    required this.label,
    required this.index,
    this.onTap,
    this.icon,
  });

  @override
  State<StatefulWidget> createState() {
    return _SidebarButtonState();
  }
}

class _SidebarButtonState extends State<SidebarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ViewPageController.stream,
      initialData:
          ViewPageController.currentIndex ?? (UserData.isAdmin ? 0 : 1),
      builder: (context, selected) => InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white24 : Colors.transparent,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        widget.icon,
                        color: selected.data == widget.index
                            ? Colors.white
                            : Colors.white60,
                      ),
                    ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: selected.data == widget.index
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        onTap: widget.onTap == null
            ? () => ViewPageController.change(widget.index)
            : () => widget.onTap!(),
      ),
    );
  }
}
