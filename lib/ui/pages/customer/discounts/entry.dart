import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/customer/product_list/add_to_cart_dialog.dart';
import 'package:rescape_web/ui/pages/customer/product_list/add_to_cart_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class CustomerDiscountsProductEntry extends StatefulWidget {
  final ProductModel product;
  final BoxConstraints constraints;

  CustomerDiscountsProductEntry({
    required this.product,
    required this.constraints,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomerDiscountsProductEntryState();
  }
}

class _CustomerDiscountsProductEntryState
    extends State<CustomerDiscountsProductEntry> {
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
                  if (widget.product.discount != null &&
                      widget.product.discount != 0)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white70,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            '-${widget.product.discount}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.red.shade300,
                              fontSize: 44,
                            ),
                          ),
                        ),
                      ),
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
              child: Text(
                widget.product.name +
                    '\n' +
                    ((widget.product.price *
                                (widget.product.discount != null
                                    ? ((100 - widget.product.discount!) / 100)
                                    : 1)) *
                            ((100 + widget.product.vat) / 100))
                        .toStringAsFixed(2) +
                    ' RSD',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
