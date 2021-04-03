import 'package:flutter/material.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';
import 'package:rescape_web/ui/pages/admin/companies/entry/details/products/edit_discount_dialog.dart';

class CompanyDetailsProductEntry extends StatefulWidget {
  final CompanyModel company;
  final ProductModel product;

  CompanyDetailsProductEntry({required this.company, required this.product});

  @override
  State<StatefulWidget> createState() {
    return _CompanyDetailsProductEntryState();
  }
}

class _CompanyDetailsProductEntryState
    extends State<CompanyDetailsProductEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
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
                  AnimatedOpacity(
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
                  if (widget.company.discounts
                      .where((e) => e.productId == widget.product.id)
                      .isNotEmpty)
                    AnimatedOpacity(
                      opacity: _isHovered ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              '-' +
                                  widget.company.discounts
                                      .firstWhere((e) =>
                                          e.productId == widget.product.id)
                                      .discount
                                      .toString() +
                                  '%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade300,
                                fontSize: 30,
                              ),
                            ),
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
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.white70,
        builder: (context) => EditCompanyProductDiscountDialog(
          company: widget.company,
          product: widget.product,
        ),
      ).whenComplete(() => setState(() {})),
    );
  }
}
