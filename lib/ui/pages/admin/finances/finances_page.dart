// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/finances.dart';
import 'package:rescape_web/logic/api/models/finance.dart';
import 'package:rescape_web/ui/pages/admin/finances/add_report_popup.dart';
import 'package:rescape_web/ui/pages/admin/finances/bloc/report_generation.dart';
import 'package:rescape_web/ui/shared/custom_table_cell.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class FinancesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FinancesPageState();
  }
}

class _FinancesPageState extends State<FinancesPage> {
  void refresh() => setState(() {});

  static Future<List<FinanceModel>> _getFinances(String? filter) async {
    List<FinanceModel> finances;

    var response;

    if (CompaniesData.instance == null) {
      response = await CompaniesAPI.getAll();
      if (response == null) throw Exception('Error. Please try again later.');
    }

    finances = await FinancesAPI.getAll();

    if (filter != null)
      finances
          .removeWhere((e) => filter == 'Uplate' ? e.amount < 0 : e.amount > 0);

    return finances;
  }

  final _reportController = StreamController.broadcast();

  final GlobalKey _repaintKey = GlobalKey();

  Future<void> _saveImage() async {
    ReportGeneration.change(false);
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white70,
        builder: (context) => Center(child: CircularProgressIndicator()));
    await Future.delayed(const Duration(milliseconds: 500));
    final RenderRepaintBoundary? boundary = _repaintKey.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    ui.Image _image = await boundary!.toImage(pixelRatio: 3);
    final imageByteData =
        await _image.toByteData(format: ui.ImageByteFormat.png);
    final content = base64Encode(imageByteData!.buffer.asUint8List());
    final anchor = html.AnchorElement(
        href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
      ..setAttribute('download', DateTime.now().toIso8601String() + '.png')
      ..click();
    anchor.remove();
    Navigator.pop(context);
    ReportGeneration.change(true);
  }

  @override
  void initState() {
    super.initState();
    ReportGeneration.init();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _reportController.stream,
      builder: (context, AsyncSnapshot filter) => FutureBuilder(
        future: _getFinances(filter.data),
        builder: (context, AsyncSnapshot<List<FinanceModel>> finances) =>
            finances.connectionState != ConnectionState.done ||
                    finances.hasError ||
                    !finances.hasData ||
                    finances.hasData &&
                        finances.data!.isEmpty &&
                        filter.data == null
                ? Center(
                    child: finances.connectionState != ConnectionState.done
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  finances.hasError
                                      ? finances.error.toString()
                                      : 'Ništa ne postoji u zapisniku. ',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                if (finances.hasData && finances.data!.isEmpty)
                                  TextButton(
                                    onPressed: () => PopupController.show(
                                      AddFinanceReportPopup(
                                        rebuildParent: refresh,
                                      ),
                                    ),
                                    child: Text(
                                      'Dodaj?',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) => ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: constraints.maxWidth > 896
                              ? const EdgeInsets.fromLTRB(20, 30, 20, 0)
                              : const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 14, 24, 14),
                                        child: Text(
                                          'Unos',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () => PopupController.show(
                                      AddFinanceReportPopup(
                                        rebuildParent: refresh,
                                      ),
                                    ),
                                  ),
                                  for (var i = 0; i < 2; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: InkWell(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            color: filter.data ==
                                                    (i == 0
                                                        ? 'Uplate'
                                                        : 'Dugovanja')
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                24, 14, 24, 14),
                                            child: Text(
                                              i == 0 ? 'Uplate' : 'Dugovanja',
                                              style: TextStyle(
                                                color: filter.data ==
                                                        (i == 0
                                                            ? 'Uplate'
                                                            : 'Dugovanja')
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () => _reportController.add(
                                            filter.data ==
                                                    (i == 0
                                                        ? 'Uplate'
                                                        : 'Dugovanja')
                                                ? null
                                                : i == 0
                                                    ? 'Uplate'
                                                    : 'Dugovanja'),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.',
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  if (constraints.maxWidth > 896)
                                    IconButton(
                                      onPressed: () async => await _saveImage(),
                                      icon: Icon(Icons.file_download),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: constraints.maxWidth > 896
                              ? const EdgeInsets.fromLTRB(20, 20, 20, 0)
                              : const EdgeInsets.symmetric(horizontal: 20),
                          child: constraints.maxWidth > 896
                              ? SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: RepaintBoundary(
                                    key: _repaintKey,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: Table(
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        border: TableBorder.all(width: 0.5),
                                        columnWidths: {
                                          0: FractionColumnWidth(0.35),
                                          1: FractionColumnWidth(0.25),
                                          3: FractionColumnWidth(0.4),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              CustomTableCell(
                                                label: 'Kompanija',
                                                expanded: true,
                                              ),
                                              CustomTableCell(
                                                label: 'Datum',
                                                expanded: true,
                                              ),
                                              CustomTableCell(
                                                label: 'Iznos',
                                                expanded: true,
                                              ),
                                            ],
                                          ),
                                          for (var report in finances.data!)
                                            TableRow(
                                              children: [
                                                CustomTableCell(
                                                  label: CompaniesData.instance!
                                                      .firstWhere((e) =>
                                                          e!.id ==
                                                          report.companyId)!
                                                      .name,
                                                  removeIcon: true,
                                                  remove: () =>
                                                      PopupController.show(
                                                    ConfirmDeletionPopup(
                                                      future: () async =>
                                                          await FinancesAPI
                                                                  .delete(
                                                                      report.id)
                                                              .whenComplete(() =>
                                                                  refresh()),
                                                    ),
                                                  ),
                                                ),
                                                CustomTableCell(
                                                  label: '${report.time.day}.'
                                                      '${report.time.month}.'
                                                      '${report.time.year}.',
                                                ),
                                                CustomTableCell(
                                                  label: NumberFormat().format(
                                                          report.amount) +
                                                      (constraints.maxWidth >
                                                              896
                                                          ? ' RSD'
                                                          : ''),
                                                  colored: true,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    for (var report in finances.data!)
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${report.time.day}.'
                                                    '${report.time.month}.'
                                                    '${report.time.year}. ',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    CompaniesData.instance!
                                                        .firstWhere((e) =>
                                                            e!.id ==
                                                            report.companyId)!
                                                        .name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                NumberFormat()
                                                        .format(report.amount) +
                                                    ' RSD',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: report.amount < 0
                                                      ? Colors.red.shade300
                                                      : Colors.green.shade300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Builder(
                                          builder: (context) {
                                            double total = 0;
                                            for (var report in finances.data!)
                                              total += report.amount;
                                            return Text(
                                              NumberFormat().format(total) +
                                                  ' RSD',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        if (constraints.maxWidth > 896)
                          Builder(
                            builder: (context) {
                              double total = 0;
                              for (var report in finances.data!)
                                total += report.amount;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(0.6),
                                    1: FractionColumnWidth(0.4),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(child: const SizedBox()),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Text(
                                              '${NumberFormat().format(double.parse(total.toStringAsFixed(2)))} RSD',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  @override
  void dispose() {
    ReportGeneration.dispose();
    _reportController.close();
    super.dispose();
  }
}
