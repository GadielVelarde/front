import 'package:flutter/material.dart';
import 'direccion_search_bottom_sheet.dart';


class SuggestionItem extends StatelessWidget {
  const SuggestionItem({
    super.key,
    required this.widget,
    required this.context,
    required this.suggestion,
    required this.isSelected,
  });

  final DireccionSearchBottomSheet widget;
  final BuildContext context;
  final MapboxSuggestion suggestion;
  final bool isSelected;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onDireccionSelected?.call(suggestion.displayAddress);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB03138) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFC7C7C7)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: isSelected ? Colors.white : const Color(0xFFB03138),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.streetWithNumber,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (suggestion.district != null)
                    Text(
                      suggestion.district!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.grey[700],
                      ),
                    ),
                  if (suggestion.secondaryInfo.isNotEmpty)
                    Text(
                      suggestion.secondaryInfo,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
