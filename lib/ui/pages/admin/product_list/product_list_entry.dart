import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/logic/api/products.dart';
import 'package:rescape_web/ui/pages/admin/product_list/edit_product_popup.dart';
import 'package:rescape_web/ui/pages/admin/product_list/product_list_page.dart';
import 'package:rescape_web/ui/shared/edit_product_dialog.dart';
import 'package:rescape_web/ui/shared/popup/confirm_deletion_popup.dart';
import 'package:rescape_web/ui/view/bloc/popup_controller.dart';

class ProductListEntry extends StatefulWidget {
  final ProductModel product;
  final BoxConstraints constraints;

  ProductListEntry({
    required this.product,
    required this.constraints,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProductListEntryState();
  }
}

class _ProductListEntryState extends State<ProductListEntry> {
  bool _isHovered = false;

  Future _delete() async => await ProductsAPI.delete(widget.product.id)
      .whenComplete(() => ProductListPage.state?.refresh());

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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: widget.constraints.maxWidth < 896
                                ? null
                                : () => PopupController.show(
                                      EditProductPopup(product: widget.product),
                                    ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red[300],
                            ),
                            onPressed: widget.constraints.maxWidth < 896
                                ? null
                                : () => PopupController.show(
                                      ConfirmDeletionPopup(future: _delete),
                                    ),
                          ),
                        ],
                      ),
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
                widget.product.name,
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
      onTap: widget.constraints.maxWidth < 896
          ? () => showDialog(
                context: context,
                builder: (context) => EditProductDialog(
                  product: widget.product,
                ),
              )
          : () {},
    );
  }
}
