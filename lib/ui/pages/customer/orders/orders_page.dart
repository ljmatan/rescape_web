import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/models/order_model.dart';
import 'package:rescape_web/logic/api/orders.dart';
import 'package:rescape_web/logic/api/reports.dart';
import 'package:rescape_web/ui/pages/customer/orders/order_details.dart';

class CustomerOrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerOrdersPageState();
  }
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: constraints.maxWidth < 896
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.all(30),
        child: FutureBuilder(
          future: OrdersAPI.byCustomer(UserData.instance.companyId!),
          builder: (context, AsyncSnapshot<List<OrderModel>> orders) => orders
                          .connectionState !=
                      ConnectionState.done ||
                  orders.hasError ||
                  orders.hasData && orders.data!.isEmpty
              ? Center(
                  child: orders.connectionState != ConnectionState.done
                      ? CircularProgressIndicator()
                      : Text(
                          orders.hasError
                              ? orders.error.toString()
                              : 'Nemate zapisanih porudžbi.',
                          style: const TextStyle(fontSize: 21),
                        ),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 18),
                  children: [
                    for (var order in orders.data!)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${order.time.day}.${order.time.month}.${order.time.year}.  -  ',
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
                                    icon: Icon(Icons.list_alt),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CustomerOrderDetails(
                                        order: order,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Text(
                                      'PDF',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    ),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor: Colors.white70,
                                        builder: (context) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                      try {
                                        final pdfResponse =
                                            await ReportsAPI.getById(order.id);
                                        if (pdfResponse['error']) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      pdfResponse['message'])));
                                        } else {
                                          Navigator.pop(context);
                                          if (pdfResponse['file'] == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Datoteka nije pronađena. Bit će Vam dostupna u najbržem mogućem roku.')));
                                          } else {
                                            final pdfBytes = base64Decode(
                                                pdfResponse['file']);
                                            final blob = html.Blob(
                                              [pdfBytes],
                                              'application/pdf',
                                            );
                                            {
                                              final url = html.Url
                                                  .createObjectUrlFromBlob(
                                                      blob);
                                              html.window.open(url, "_blank");
                                              html.Url.revokeObjectUrl(url);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text('$e')));
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
    );
  }
}
