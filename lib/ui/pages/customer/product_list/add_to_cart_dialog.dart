import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rescape_web/data/cart/cart.dart';
import 'package:rescape_web/data/cart/cart_item_model.dart';
import 'package:rescape_web/data/user/discounted_data.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/other/measures.dart';
import 'package:rescape_web/ui/pages/customer/product_list/add_to_cart_popup.dart';

class AddToCartMobile extends StatefulWidget {
  final ProductModel product;

  AddToCartMobile({required this.product});

  @override
  State<StatefulWidget> createState() {
    return _AddToCartMobileState();
  }
}

class _AddToCartMobileState extends State<AddToCartMobile> {
  final TextEditingController _amountController = TextEditingController();

  bool _uploading = false;

  String? _error;

  late Measure _measureType;

  final _measureController = StreamController.broadcast();

  late StreamSubscription _measureSubscribtion;

  @override
  void initState() {
    super.initState();
    _measureType = widget.product.measure;
    _measureSubscribtion =
        _measureController.stream.listen((type) => _measureType = type);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40, top: 30),
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      if (widget.product.inPackage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            (widget.product.measure == Measure.kg
                                    ? 'Komad cca '
                                    : '') +
                                widget.product.inPackage!.toStringAsFixed(
                                    widget.product.measure == Measure.kg
                                        ? 2
                                        : 0) +
                                (widget.product.measure == Measure.kg
                                    ? 'kg'
                                    : ' komada u kutiji'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          autofocus: true,
                          controller: _amountController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Količina',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          AddToCartMeasureOption(
                            enabled: widget.product.inPackage != null,
                            measureController: _measureController,
                            initialData: _measureType,
                            type: widget.product.measure,
                            label: widget.product.measure == Measure.qty
                                ? 'Komada'
                                : 'Kila',
                          ),
                          const SizedBox(width: 10),
                          AddToCartMeasureOption(
                            enabled: widget.product.inPackage != null,
                            measureController: _measureController,
                            initialData: _measureType,
                            type: widget.product.measure == Measure.qty
                                ? Measure.box
                                : Measure.qty,
                            label: widget.product.measure == Measure.qty
                                ? 'Kutija'
                                : 'Komada',
                          ),
                        ],
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _error!,
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: InkWell(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: SizedBox(
                              width: 150,
                              height: 56,
                              child: Center(
                                child: _uploading
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'DODAJ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (_amountController.text.isNotEmpty &&
                                ((_measureType == Measure.qty ||
                                            _measureType == Measure.box) &&
                                        int.tryParse(_amountController.text) !=
                                            null ||
                                    _measureType == Measure.kg &&
                                        double.tryParse(
                                                _amountController.text) !=
                                            null)) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Proizvod dodan u korpu')));
                              double? discount;
                              discount = widget.product.discount;
                              if (UserData.instance.discount != null &&
                                  UserData.instance.discount! > (discount ?? 0))
                                discount = UserData.instance.discount;
                              for (var discountedItem
                                  in DiscountedData.instance!)
                                if (discountedItem.productId ==
                                        widget.product.id &&
                                    discountedItem.discount > (discount ?? 0))
                                  discount = discountedItem.discount;
                              final num amount = widget.product.measure ==
                                      Measure.kg
                                  ? _measureType == Measure.kg
                                      ? double.parse(_amountController.text)
                                      : double.parse(_amountController.text) *
                                          widget.product.inPackage!
                                  : _measureType == Measure.qty
                                  ? int.parse(_amountController.text)
                                  : int.parse(_amountController.text) *
                                      widget.product.inPackage!;
                              final price = ((widget.product.price *
                                      ((100 + widget.product.vat) / 100)) *
                                  ((100 - (discount ?? 0)) / 100));
                              CartItems.addToOrder(
                                CartItemModel(
                                  id: widget.product.id,
                                  name: widget.product.name,
                                  amount: amount,
                                  vat: widget.product.vat,
                                  price: amount * price,
                                  measure: widget.product.measure,
                                  discount: discount,
                                ),
                              );
                            } else
                              setState(() =>
                                  _error = 'Molimo proverite unesene podatke.');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _measureSubscribtion.cancel();
    _amountController.dispose();
    _measureController.close();
    super.dispose();
  }
}
