import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/admin/product_list/edit_product_popup.dart';
import 'package:rescape_web/ui/shared/edit_product_dialog.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class DiscountsProductEntry extends StatefulWidget {
  final ProductModel product;
  final BoxConstraints constraints;

  DiscountsProductEntry({required this.product, required this.constraints});

  @override
  State<StatefulWidget> createState() {
    return _DiscountsProductEntryState();
  }
}

class _DiscountsProductEntryState extends State<DiscountsProductEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.product.photo == null ? Colors.black26 : null,
                borderRadius: BorderRadius.circular(40),
                image: widget.product.photo == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(widget.product.photo!),
                      ),
                boxShadow: kElevationToShadow[1],
              ),
              child: AnimatedOpacity(
                opacity: _isHovered ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
              child: Text(
                '${widget.product.name}\n${widget.product.price + (widget.product.price * (widget.product.vat / 100))} - ${widget.product.discount}% = '
                '${(widget.product.price + (widget.product.price * (widget.product.vat / 100)) * ((100 - widget.product.discount!) / 100)).toStringAsFixed(1)}',
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
              EditProductPopup(product: widget.product),
            )
          : showDialog(
              context: context,
              builder: (context) => EditProductDialog(
                product: widget.product,
              ),
            ),
    );
  }
}
