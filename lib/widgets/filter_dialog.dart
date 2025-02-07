import 'package:flutter/material.dart';

void showFilterDialog(
  BuildContext context,
  String title,
  List<String> filterData,
  String selectedFilter,
  Function(String) onFilterSelected,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...filterData.map(
              (value) {
                return RadioListTile(
                  title: Text(value),
                  value: value,
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    onFilterSelected(value as String);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
