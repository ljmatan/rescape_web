import 'package:flutter/material.dart';
import 'bloc/selected_filter_controller.dart';

class NavMenuButton extends StatelessWidget {
  final String label, filter;

  NavMenuButton({required this.label, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: SelectedFilterController.stream,
        initialData: 'products',
        builder: (context, selected) => InkWell(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color:
                      selected.data == filter ? Colors.black : Colors.black38,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          onTap: () => SelectedFilterController.change(filter),
        ),
      ),
    );
  }
}
