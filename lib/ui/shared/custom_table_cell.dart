import 'package:flutter/material.dart';
import 'package:rescape_web/ui/pages/admin/finances/bloc/report_generation.dart';

class CustomTableCell extends StatelessWidget {
  final bool expanded, colored, removeIcon;
  final String label;
  final String? discount;
  final Function? remove;

  CustomTableCell({
    this.expanded: false,
    required this.label,
    this.colored: false,
    this.discount,
    this.removeIcon: false,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: expanded ? 10 : 8),
        child: Stack(
          children: [
            if (removeIcon)
              Positioned(
                top: 0,
                bottom: 0,
                left: 12,
                child: ReportGeneration.stream != null
                    ? StreamBuilder(
                        stream: ReportGeneration.stream,
                        initialData: true,
                        builder: (context, AsyncSnapshot visible) =>
                            visible.data
                                ? InkWell(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red.shade300,
                                    ),
                                    onTap: () => remove!(),
                                  )
                                : const SizedBox(),
                      )
                    : InkWell(
                        child: Icon(
                          Icons.close,
                          color: Colors.red.shade300,
                        ),
                        onTap: () => remove!(),
                      ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: expanded ? 22 : 18,
                    fontWeight: expanded ? FontWeight.bold : null,
                    color: colored
                        ? label.startsWith('-')
                            ? Colors.red.shade300
                            : Colors.green
                        : Colors.black,
                  ),
                ),
                if (discount != null)
                  Text(
                    discount!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
