import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class CampsiteSearchBar extends ConsumerWidget {
  const CampsiteSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.isFloating = false,
    this.searchQuery = '',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isFloating;
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildFloatingSearchBar();
  }

  Widget _buildFloatingSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Where do you want to camp?',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    onPressed: onClear,
                    icon: Icon(Icons.clear, color: AppColors.textSecondary),
                  )
                  : Icon(Icons.tune, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hoverColor: Colors.white,
        ),
      ),
    );
  }
}
