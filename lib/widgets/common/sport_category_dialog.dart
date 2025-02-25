import 'package:flutter/material.dart';
import '../../models/category.dart';

void showSportsFilterDialog(
  BuildContext context,
  String title,
  SportsCategories selectedFilter,
  Function(SportsCategories) onFilterSelected,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...SportsCategories.values.map(
              (value) {
                return RadioListTile(
                  title: Text(value.categoryString),
                  value: value,
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    onFilterSelected(value!);
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
