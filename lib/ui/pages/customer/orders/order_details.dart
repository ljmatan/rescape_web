import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/logic/api/models/order_model.dart';
import 'package:rescape_web/other/measures.dart';

class CustomerOrderDetails extends StatelessWidget {
  final OrderModel order;

  CustomerOrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        text: '${NumberFormat().format(order.total)} RSD',
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
                            (item.measure == Measure.kg ? '' : '×') +
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
