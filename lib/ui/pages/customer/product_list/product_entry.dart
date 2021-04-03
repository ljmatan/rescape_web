import 'package:flutter/material.dart';
import 'package:rescape_web/data/user/discounted_data.dart';
import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/customer/product_list/add_to_cart_dialog.dart';
import 'package:rescape_web/ui/pages/customer/product_list/add_to_cart_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class CustomerProductListEntry extends StatefulWidget {
  final ProductModel product;
  final BoxConstraints constraints;

  CustomerProductListEntry({required this.product, required this.constraints});

  @override
  State<StatefulWidget> createState() {
    return _CustomerProductListEntryState();
  }
}

class _CustomerProductListEntryState extends State<CustomerProductListEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[1],
                color: widget.product.photo == null ? Colors.black26 : null,
                borderRadius: BorderRadius.circular(40),
                image: widget.product.photo == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(widget.product.photo!),
                      ),
              ),
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      double? discount;
                      discount = widget.product.discount;
                      if (UserData.instance.discount != null &&
                          UserData.instance.discount! > (discount ?? 0))
                        discount = UserData.instance.discount;
                      for (var discountedItem in DiscountedData.instance!)
                        if (discountedItem.productId == widget.product.id &&
                            discountedItem.discount > (discount ?? 0))
                          discount = discountedItem.discount;
                      if (discount != null)
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.white70,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                '-$discount%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red.shade300,
                                  fontSize: 44,
                                ),
                              ),
                            ),
                          ),
                        );
                      else
                        return const SizedBox();
                    },
                  ),
                  AnimatedOpacity(
                    opacity: _isHovered ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Icon(Icons.add, size: 64),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
              child: Builder(
                builder: (context) {
                  double? discount;
                  discount = widget.product.discount;
                  if (UserData.instance.discount != null &&
                      UserData.instance.discount! > (discount ?? 0))
                    discount = UserData.instance.discount;
                  for (var discountedItem in DiscountedData.instance!)
                    if (discountedItem.productId == widget.product.id &&
                        discountedItem.discount > (discount ?? 0))
                      discount = discountedItem.discount;
                  return Text(
                    widget.product.name +
                        '\n' +
                        ((widget.product.price *
                                    ((100 + widget.product.vat) / 100)) *
                                ((100 - (discount ?? 0)) / 100))
                            .toStringAsFixed(2) +
                        ' RSD',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      onHover: (isHovered) => setState(() => _isHovered = isHovered),
      onTap: () => widget.constraints.maxWidth > 896
          ? PopupController.show(
              AddToCartPopup(product: widget.product),
            )
          : showDialog(
              context: context,
              builder: (context) => AddToCartMobile(product: widget.product),
            ),
    );
  }
}
