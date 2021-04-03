import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/orders.dart';
import 'package:rescape_web/logic/api/reports.dart';
import 'package:rescape_web/ui/pages/admin/orders/order_display.dart';
import 'bloc/selected_filter_controller.dart';
import 'nav_menu_button.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    SelectedFilterController.init();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              constraints.maxWidth > 896 ? 16 : 0,
            ),
            child: Row(
              children: [
                NavMenuButton(
                  label: 'Aktivne',
                  filter: 'new',
                ),
                NavMenuButton(
                  label: 'Procesuirane',
                  filter: 'processed',
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: SelectedFilterController.stream,
              initialData: 'new',
              builder: (context, AsyncSnapshot filter) => FutureBuilder(
                future: OrdersAPI.getAll(filter.data),
                builder: (context, AsyncSnapshot orders) => orders
                                .connectionState !=
                            ConnectionState.done ||
                        orders.hasError ||
                        orders.hasData && orders.data!.isEmpty
                    ? Center(
                        child: orders.connectionState != ConnectionState.done
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  orders.hasError
                                      ? orders.error.toString()
                                      : 'Nema aktivnih porudžbi.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          for (var order in orders.data!)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: CompaniesData.instance!
                                                .firstWhere((e) =>
                                                    e!.id == order.companyId)!
                                                .name,
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${order.time.day}.${order.time.month}.${order.time.year}.  -  ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${NumberFormat().format(order.total)} RSD',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.list),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AdminOrderDisplay(
                                              order: order,
                                            ),
                                          ),
                                        ),
                                        if (filter.data == 'new' &&
                                            constraints.maxWidth > 896)
                                          IconButton(
                                            icon: Icon(Icons.upload_file),
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();
                                              if (result != null) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  barrierColor: Colors.white70,
                                                  builder: (context) => Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                                try {
                                                  final decoded =
                                                      await ReportsAPI.upload(
                                                    base64Encode(result
                                                        .files.first.bytes!),
                                                    order.id,
                                                    order.companyId,
                                                  );
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(decoded[
                                                                  'error']
                                                              ? decoded[
                                                                  'message']
                                                              : 'PDF uspešno arhiviran.')));
                                                  if (!decoded['error'])
                                                    setState(() {});
                                                } catch (e) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text('$e')));
                                                }
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SelectedFilterController.dispose();
    super.dispose();
  }
}
