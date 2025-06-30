import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'campsite_card_unified.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class CampsiteGridLayout extends ConsumerWidget {
  const CampsiteGridLayout({
    super.key,
    required this.campsites,
    required this.onCampsiteSelected,
    this.layout = CampsiteCardLayout.grid,
    this.crossAxisCount,
    this.childAspectRatio = 0.75,
    this.mainAxisSpacing = 24.0,
    this.crossAxisSpacing = 24.0,
    this.padding = const EdgeInsets.all(24),
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final List<dynamic> campsites;
  final ValueChanged<String> onCampsiteSelected;
  final CampsiteCardLayout layout;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets padding;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: LoadingWidget(message: 'Loading campsites...')),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AppErrorWidget(message: errorMessage!, onRetry: onRetry),
        ),
      );
    }

    if (campsites.isEmpty) {
      return _buildEmptyState();
    }

    return ResponsiveLayout(
      mobile: _buildMobileGrid(),
      desktop: _buildDesktopGrid(),
    );
  }

  Widget _buildMobileGrid() {
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: childAspectRatio * 1.9,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: campsites.length,
      itemBuilder: (context, index) => _buildCampsiteCard(campsites[index]),
    );
  }

  Widget _buildDesktopGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            crossAxisCount ?? (constraints.maxWidth / 400).floor().clamp(1, 3);
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * crossAxisSpacing) / columns;

        return Wrap(
          spacing: crossAxisSpacing,
          runSpacing: mainAxisSpacing,
          children:
              campsites.map((campsite) {
                return SizedBox(
                  width: itemWidth,
                  child: _buildCampsiteCard(campsite),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildCampsiteCard(dynamic campsite) {
    return CampsiteCardUnified(
      campsite: campsite,
      layout: layout,
      onTap: () => onCampsiteSelected(campsite.id),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cabin, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No campsites found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
