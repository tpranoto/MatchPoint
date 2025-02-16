import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/common.dart';

class FilterBar extends StatelessWidget {
  final SportsCategories selectedCategory;
  final String postalCode;
  final Function() onPressed;
  const FilterBar({
    super.key,
    required this.selectedCategory,
    required this.onPressed,
    required this.postalCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: IconWithText(
            icon: Icons.location_on_outlined,
            text: postalCode,
          ),
        ),
        Flexible(
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.filter_list),
            label: Text(selectedCategory == SportsCategories.all
                ? "Category"
                : selectedCategory.categoryString),
          ),
        ),
      ],
    );
  }
}

class SearchVenueBar extends StatefulWidget {
  final TextEditingController outputCtrl;
  final SportsCategories selectedCat;
  final Function(String) onSubmit;

  const SearchVenueBar({
    super.key,
    required this.outputCtrl,
    required this.selectedCat,
    required this.onSubmit,
  });

  @override
  State<SearchVenueBar> createState() => _SearchVenueBarState();
}

class _SearchVenueBarState extends State<SearchVenueBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.outputCtrl,
      decoration: InputDecoration(
        labelText: "Venue",
        hintText: "Search by venue name",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.outputCtrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.outputCtrl.clear();
                  widget.onSubmit("");
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      onSubmitted: widget.onSubmit,
    );
  }
}
