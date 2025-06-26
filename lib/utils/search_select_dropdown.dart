import 'package:flutter/material.dart';

class SearchSelectDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemLabel;
  final ValueChanged<T> onItemSelected;
  final TextEditingController
  searchController; // External controller for search
  final double width; // To match the width of the input field

  const SearchSelectDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.itemLabel,
    required this.onItemSelected,
    required this.searchController,
    required this.width,
  });

  @override
  State<SearchSelectDropdown<T>> createState() =>
      _SearchSelectDropdownState<T>();
}

class _SearchSelectDropdownState<T> extends State<SearchSelectDropdown<T>> {
  @override
  void initState() {
    super.initState();
    // Listen to changes on the external searchController to filter items
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant SearchSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the searchController itself changes, update the listener
    if (oldWidget.searchController != widget.searchController) {
      oldWidget.searchController.removeListener(_onSearchChanged);
      widget.searchController.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    // Trigger a rebuild to re-filter the items based on the updated searchController text
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchController.text.toLowerCase();
    final filteredItems = widget.items.where((item) {
      return widget.itemLabel(item).toLowerCase().contains(query);
    }).toList();

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: widget.width, // Match the width of the input field
        decoration: BoxDecoration(
          color: Colors.white, // fill_4D9PWU
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
              offset: const Offset(
                0,
                1,
              ), // Adjusted shadow for dropdown appearance
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.black.withAlpha(38),
              offset: const Offset(0, 1),
              blurRadius: 12,
            ),
          ],
        ),
        // No padding around the entire container, items will have their own padding
        child: ClipRRect(
          // Clip to apply border radius to scrollable content
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height *
                  0.4, // Max height for scrollability
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: filteredItems.map((item) {
                  final isSelected = item == widget.selectedItem;
                  return _SearchSelectDropdownItem(
                    text: widget.itemLabel(item),
                    isSelected: isSelected,
                    onTap: () {
                      widget.onItemSelected(item);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchSelectDropdownItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchSelectDropdownItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45, // Figma height
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF232323)
              : Colors
                    .transparent, // Selected item background, unselected is transparent
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ), // Consistent padding for all items
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align text to start
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.12, // Figma lineHeight
                  letterSpacing: 0.02, // Figma letterSpacing
                  color: isSelected
                      ? Colors.white
                      : const Color(
                          0xFF1D1929,
                        ), // Selected text color, unselected text color
                ),
              ),
            ),
            if (isSelected)
              const SizedBox(
                width: 15, // Figma width
                height: 15, // Figma height
                child: Icon(
                  Icons.check, // Using a standard check icon for simplicity
                  color: Colors.white, // stroke_IJA8EV
                  size: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
