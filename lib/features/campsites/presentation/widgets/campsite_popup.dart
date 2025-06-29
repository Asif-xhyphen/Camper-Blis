import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/campsite.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';

class CampsitePopup extends StatelessWidget {
  final Campsite campsite;
  final VoidCallback? onTap;

  const CampsitePopup({super.key, required this.campsite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleAndPrice(),
                    const SizedBox(height: 8),
                    _buildDescription(),
                    const SizedBox(height: 12),
                    _buildAmenities(),
                    const SizedBox(height: 12),
                    _buildBottomInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        height: 120,
        width: double.infinity,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: campsite.photo,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.terrain,
                      size: 40,
                      color: AppColors.primaryGreen,
                    ),
                  ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  campsite.formattedPrice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            campsite.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.star, size: 16, color: Colors.amber[600]),
        const SizedBox(width: 4),
        Text(
          '4.${(campsite.pricePerNight * 0.1).round()}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      campsite.briefDescription,
      style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.3),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAmenities() {
    final amenities = campsite.amenities;
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: amenities.map((amenity) => _buildAmenityChip(amenity)).toList(),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    IconData icon;
    switch (amenity) {
      case 'Close to Water':
        icon = Icons.water;
        break;
      case 'Campfire Allowed':
        icon = Icons.local_fire_department;
        break;
      default:
        icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(
            amenity,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Row(
      children: [
        if (campsite.suitableFor.isNotEmpty) ...[
          Icon(Icons.people_outline, size: 16, color: Colors.black45),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              campsite.suitableFor.take(2).join(', '),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (campsite.hostLanguages.isNotEmpty) ...[
          const SizedBox(width: 12),
          Icon(Icons.language, size: 16, color: Colors.black45),
          const SizedBox(width: 4),
          Text(
            campsite.hostLanguages.take(2).join(', ').toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
