import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.selected,
    required this.onPressed,
    required this.label,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColor.yellow : AppColor.blackL2,
        foregroundColor: selected ? Colors.black : Colors.white,
        minimumSize: .zero,
        padding: .symmetric(vertical: 8, horizontal: 16),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: .center,
        children: [AppTextStyle.bold12(color: null).text(label)],
      ),
    );
  }
}
