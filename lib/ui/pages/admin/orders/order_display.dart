import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/models/order_model.dart';
import 'package:rescape_web/logic/api/orders.dart';
import 'package:rescape_web/other/measures.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class AdminOrderDisplay extends StatelessWidget {
  final OrderModel order;
  final Function rebuild;

  AdminOrderDisplay({required this.order, required this.rebuild});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (MediaQuery.of(context).size.width > 896)
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red.shade300),
                    onPressed: () => PopupController.show(ConfirmDeletionPopup(
                        future: () async =>
                            await OrdersAPI.delete(order.id).then((value) {
                              if (!value['error']) rebuild();
                              return value;
                            }))),
                  )
                else
                  const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 21,
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
                        text: CompaniesData.instance!
                            .firstWhere((e) => e!.id == order.companyId)!
                            .name,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          for (var item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${item.name} ',
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(
                            (item.measure == Measure.kg ? '' : '??') +
                                '${item.amount}' +
                                (item.measure == Measure.kg ? 'kg' : ''),
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      Text(
                        '${NumberFormat().format(item.price)} RSD',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 16, 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${NumberFormat().format(order.total)} RSD',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          if (order.specials != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Row(
                children: [
                  Text(
                    'PROMOCIJE: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  for (int i = 0; i < order.specials!.length; i++)
                    Text(
                      (i != 0 ? ', ' : '') + '${order.specials![i]}',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
