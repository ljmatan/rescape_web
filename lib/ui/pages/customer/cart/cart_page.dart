import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescape_web/data/cart/cart.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';
import 'package:rescape_web/logic/api/orders.dart';
import 'package:rescape_web/other/measures.dart';
import 'package:rescape_web/ui/shared/custom_table_cell.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  static int? _locationNumber;

  static Future<List<LocationModel>> _getLocations() async {
    List<LocationModel> locations = [];

    final userInfoDecoded = jsonDecode(
        (await HTTPHelper.get('/users/${UserData.instance.username}/locations'))
            .body);

    if (userInfoDecoded['error']) throw Exception(userInfoDecoded['message']);

    final locationsInfoDecoded = jsonDecode((await HTTPHelper.get(
            '/companies/${UserData.instance.companyId}/locations'))
        .body);

    if (locationsInfoDecoded['error'])
      throw Exception(userInfoDecoded['message']);

    for (var location in locationsInfoDecoded['locations'])
      for (var locationNumber in userInfoDecoded['locations'])
        if (location['locationNumber'] == locationNumber)
          locations.add(
            LocationModel(
              street: location['street'],
              city: location['city'],
              locationNumber: location['locationNumber'],
            ),
          );

    if (locations.length == 1) _locationNumber = locations.first.locationNumber;

    return locations;
  }

  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return CartItems.instance.isEmpty
        ? Center(
            child: Text(
              'Nema proizvoda u korpi.',
              style: const TextStyle(fontSize: 20),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) => ListView(
              padding: constraints.maxWidth < 896
                  ? EdgeInsets.symmetric(horizontal: 16)
                  : const EdgeInsets.all(20),
              children: [
                if (CartItems.specials.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          'PROMOCIJE: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        for (int i = 0; i < CartItems.specials.length; i++)
                          Text(
                            (i != 0 ? ', ' : '') + '${CartItems.specials[i]}',
                            style: const TextStyle(fontSize: 18),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width /
                            (constraints.maxWidth < 896 ? 2 : 4),
                        child: FutureBuilder(
                          future: _getLocations(),
                          builder: (context,
                                  AsyncSnapshot<List<LocationModel>>
                                      locations) =>
                              locations.connectionState !=
                                          ConnectionState.done ||
                                      locations.hasError
                                  ? Text(
                                      locations.connectionState !=
                                              ConnectionState.done
                                          ? 'Dobavljamo lokacije'
                                          : locations.error.toString(),
                                    )
                                  : DropdownButton(
                                      value: _locationNumber,
                                      hint: Text('Lokacija'),
                                      isExpanded: true,
                                      items: [
                                        for (var location in locations.data!)
                                          DropdownMenuItem(
                                            child: Text(
                                              '${location.street}, ${location.city}',
                                            ),
                                            value: location.locationNumber,
                                          ),
                                      ],
                                      onChanged: (int? number) => setState(
                                        () => _locationNumber = number!,
                                      ),
                                    ),
                        ),
                      ),
                      InkWell(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
                            child: Text(
                              'Poruči',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (_locationNumber == null)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Molimo odaberite lokaciju')));
                          else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.white70,
                                builder: (context) =>
                                    Center(child: CircularProgressIndicator()));
                            double total = 0;
                            for (var item in CartItems.instance)
                              total += item.price;
                            final Map body = {
                              'time': DateTime.now().toIso8601String(),
                              'companyId': UserData.instance.companyId,
                              'total': total,
                              'items': [
                                for (var item in CartItems.instance)
                                  {
                                    'name': item.name,
                                    'amount': item.amount,
                                    'measure': item.measure == Measure.kg
                                        ? 'KG'
                                        : 'QTY',
                                    'price': item.price,
                                    'discount': item.discount,
                                  }
                              ],
                              if (CartItems.specials.isNotEmpty)
                                'specials': CartItems.specials,
                            };
                            try {
                              final decoded = await OrdersAPI.create(body);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(decoded['error']
                                          ? decoded['message']
                                          : 'Porudžba uspešno obavljena.')));
                              CartItems.clearAll();
                              setState(() {});
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('$e')));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                constraints.maxWidth > 896
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder.all(width: 0.5),
                            columnWidths: {
                              0: FractionColumnWidth(0.4),
                              1: FractionColumnWidth(0.1),
                              2: FractionColumnWidth(0.1),
                              3: FractionColumnWidth(0.1),
                              4: FractionColumnWidth(0.3),
                            },
                            children: [
                              TableRow(
                                children: [
                                  CustomTableCell(
                                    label: 'Proizvod',
                                    expanded: true,
                                  ),
                                  CustomTableCell(
                                    label: 'J.M.',
                                    expanded: true,
                                  ),
                                  CustomTableCell(
                                    label: 'Količina',
                                    expanded: true,
                                  ),
                                  CustomTableCell(
                                    label: 'PDV',
                                    expanded: true,
                                  ),
                                  CustomTableCell(
                                    label: 'Cena',
                                    expanded: true,
                                  ),
                                ],
                              ),
                              for (var item in CartItems.instance)
                                TableRow(
                                  children: [
                                    CustomTableCell(
                                      label: item.name,
                                      discount: item.discount != null
                                          ? ' -${item.discount}%'
                                          : null,
                                      removeIcon: true,
                                      remove: () {
                                        CartItems.removeFromOrder(item.id);
                                        setState(() {});
                                      },
                                    ),
                                    CustomTableCell(
                                      label: item.measure == Measure.kg
                                          ? 'KG'
                                          : 'KOM',
                                    ),
                                    CustomTableCell(
                                      label: item.amount.toString(),
                                    ),
                                    CustomTableCell(
                                      label: item.vat.toString() + '%',
                                    ),
                                    CustomTableCell(
                                      label: NumberFormat().format(item.price) +
                                          ' RSD',
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              double total = 0;
                              for (var item in CartItems.instance)
                                total += item.price;
                              return Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.7),
                                  1: FractionColumnWidth(0.3),
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
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        key: _key,
                        children: [
                          for (var item in CartItems.instance)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  NumberFormat().format(item.price) +
                                      ' RSD ' +
                                      item.name +
                                      ' ' +
                                      item.amount.toString() +
                                      (item.measure == Measure.kg
                                          ? 'kg'
                                          : ' kom'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    CartItems.removeFromOrder(item.id);
                                    setState(() => _key = UniqueKey());
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
              ],
            ),
          );
  }
}
