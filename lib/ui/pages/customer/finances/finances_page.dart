import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/finance.dart';
import 'package:rescape_web/ui/shared/custom_table_cell.dart';

class CustomerFinancesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerFinancesPageState();
  }
}

class _CustomerFinancesPageState extends State<CustomerFinancesPage> {
  static Future<List<FinanceModel>> _getFinances(String? filter) async {
    List<FinanceModel> finances = [];

    var response;

    if (CompaniesData.instance == null) {
      response = await CompaniesAPI.getAll();
      if (response == null) throw Exception('Error. Please try again later.');
    }

    final decoded = jsonDecode(
        (await HTTPHelper.get('/finances/debts/${UserData.instance.companyId}'))
            .body);

    if (decoded['error']) throw Exception(decoded['message']);

    finances = [
      for (var finance in decoded['reports'])
        FinanceModel(
          id: finance['_id'],
          companyId: finance['companyId'],
          time: DateTime.parse(finance['time']),
          amount: finance['amount'],
        ),
    ];

    if (filter != null)
      finances
          .removeWhere((e) => filter == 'Uplate' ? e.amount < 0 : e.amount > 0);

    return finances;
  }

  final _reportController = StreamController.broadcast();

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
                            child: Text(
                              finances.hasError
                                  ? finances.error.toString()
                                  : 'Ništa ne postoji u zapisniku.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) => ListView(
                      children: [
                        Padding(
                          padding: constraints.maxWidth > 896
                              ? const EdgeInsets.fromLTRB(20, 30, 20, 0)
                              : const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  for (var i = 0; i < 2; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
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
                                                  : 'Dugovanja',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                          .firstWhere(
                                              (e) => e!.id == report.companyId)!
                                          .name,
                                    ),
                                    CustomTableCell(
                                      label: '${report.time.day}.'
                                          '${report.time.month}.'
                                          '${report.time.year}.',
                                    ),
                                    CustomTableCell(
                                      label:
                                          NumberFormat().format(report.amount) +
                                              ' RSD',
                                      colored: true,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
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
    _reportController.close();
    super.dispose();
  }
}
