import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/campsite_detail_controller.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../domain/entities/campsite.dart';

class CampsiteDetailPage extends ConsumerStatefulWidget {
  const CampsiteDetailPage({super.key, required this.campsiteId});

  final String campsiteId;

  @override
  ConsumerState<CampsiteDetailPage> createState() => _CampsiteDetailPageState();
}

class _CampsiteDetailPageState extends ConsumerState<CampsiteDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Hardcoded reviews data
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Sarah Johnson',
      'rating': 5,
      'date': '2 weeks ago',
      'comment':
          'Amazing campsite! The lake view was breathtaking and the facilities were clean. Perfect for a weekend getaway with family.',
      'avatar': '🌟',
    },
    {
      'name': 'Mike Chen',
      'rating': 4,
      'date': '1 month ago',
      'comment':
          'Great location and very peaceful. The fire pit area was well-maintained. Only minor issue was the Wi-Fi connection was a bit spotty.',
      'avatar': '🏕️',
    },
    {
      'name': 'Emma Davis',
      'rating': 5,
      'date': '1 month ago',
      'comment':
          'Loved every minute of our stay! The hiking trails nearby are fantastic and the sunrise over the lake is unforgettable.',
      'avatar': '🥾',
    },
    {
      'name': 'Alex Thompson',
      'rating': 4,
      'date': '2 months ago',
      'comment':
          'Excellent campsite with great amenities. The picnic tables were in good condition and there was plenty of space for our tent.',
      'avatar': '⛺',
    },
    {
      'name': 'Lisa Martinez',
      'rating': 5,
      'date': '2 months ago',
      'comment':
          'Perfect spot for stargazing! Very dark skies and minimal light pollution. The restrooms were clean and well-stocked.',
      'avatar': '✨',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getEstimatedDateText(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Available for $years+ years';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Available for $months+ months';
    } else {
      return 'Recently added';
    }
  }

  @override
  Widget build(BuildContext context) {
    final campsite = ref.watch(currentCampsiteProvider(widget.campsiteId));
    final isLoading = ref.watch(
      campsiteDetailLoadingProvider(widget.campsiteId),
    );
    final errorMessage = ref.watch(
      campsiteDetailErrorProvider(widget.campsiteId),
    );

    if (isLoading && campsite == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Loading...', style: AppTextStyles.headingMedium),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: LoadingWidget()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Error', style: AppTextStyles.headingMedium),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Center(
          child: AppErrorWidget(
            message: errorMessage,
            onRetry: () {
              ref
                  .read(
                    campsiteDetailControllerProvider(
                      widget.campsiteId,
                    ).notifier,
                  )
                  .refreshCampsiteDetails();
            },
          ),
        ),
      );
    }

    if (campsite != null) {
      return _buildCampsiteDetail(campsite);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Campsite Not Found', style: AppTextStyles.headingMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Text('Campsite not found', style: AppTextStyles.bodyLarge),
      ),
    );
  }

  Widget _buildCampsiteDetail(Campsite campsite) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Expandable/Collapsible App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      campsite.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Price Tag
                  Positioned(
                    top: 100,
                    left: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        campsite.formattedPrice,
                        style: AppTextStyles.bodyMediumWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.overlay,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                campsite.photo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.textSecondary,
                                    child: const Icon(
                                      Icons.terrain,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Explore Before You Arrive',
                                  style: AppTextStyles.headingSmallWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Take a 360° virtual tour and\nexperience the campsite',
                                  style: AppTextStyles.bodySmallWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campsite.label, style: AppTextStyles.headingLarge),
                  const SizedBox(height: 8),
                  Text(
                    campsite.briefDescription,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...campsite.hostLanguages.map(
                        (language) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.language,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                language.toUpperCase(),
                                style: AppTextStyles.bodySmallWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...campsite.suitableFor.map(
                        (category) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.bodySmallWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.headingSmallWith(
                  color: AppColors.primary,
                ),
                unselectedLabelStyle: AppTextStyles.headingSmallWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Features'),
                  Tab(text: 'Gallery'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          ..._buildTabContent(campsite),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(campsite),
    );
  }

  List<Widget> _buildTabContent(Campsite campsite) {
    switch (_currentTabIndex) {
      case 0:
        return _buildOverviewContent(campsite);
      case 1:
        return _buildFeaturesContent(campsite);
      case 2:
        return _buildGalleryContent();
      case 3:
        return _buildReviewsContent();
      default:
        return _buildOverviewContent(campsite);
    }
  }

  List<Widget> _buildOverviewContent(Campsite campsite) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(campsite.briefDescription, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 20),
              Text('About this location', style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),
              Text(
                _buildDetailedDescription(campsite),
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location Details', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    _buildLocationDetail(
                      Icons.location_on,
                      'Coordinates',
                      campsite.geoLocation.displayCoordinates,
                    ),
                    const SizedBox(height: 8),
                    _buildLocationDetail(
                      Icons.access_time,
                      'Available since',
                      _getEstimatedDateText(campsite.createdAt),
                    ),
                    const SizedBox(height: 8),
                    _buildLocationDetail(
                      Icons.euro,
                      'Price per night',
                      campsite.formattedPrice,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text('What makes it special', style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final features = _buildCampsiteFeatures(campsite);

          if (index >= features.length) return null;

          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(features[index], style: AppTextStyles.bodyLarge),
                ),
              ],
            ),
          );
        }, childCount: _buildCampsiteFeatures(campsite).length),
      ),
    ];
  }

  Widget _buildLocationDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodyMediumWith(fontWeight: FontWeight.w500),
        ),
        Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
      ],
    );
  }

  String _buildDetailedDescription(Campsite campsite) {
    String description = 'This beautiful campsite offers ';

    List<String> features = [];
    if (campsite.isCloseToWater) {
      features.add('stunning water views and direct access to swimming');
    }
    if (campsite.isCampFireAllowed) {
      features.add('cozy campfire evenings under the stars');
    }

    if (features.isNotEmpty) {
      description += features.join(' and ') + '. ';
    }

    description +=
        'Our hosts speak ${campsite.hostLanguages.join(', ')} and welcome ';
    description += campsite.suitableFor.join(', ').toLowerCase();
    description +=
        '. This is the perfect destination for those seeking a memorable outdoor experience.';

    return description;
  }

  List<String> _buildCampsiteFeatures(Campsite campsite) {
    List<String> features = [];

    if (campsite.isCloseToWater) {
      features.add('Direct water access for swimming and water activities');
    }
    if (campsite.isCampFireAllowed) {
      features.add('Campfire allowed for cozy evening gatherings');
    }

    features.add(
      'Multilingual hosts speaking ${campsite.hostLanguages.join(', ')}',
    );
    features.add(
      'Perfect for ${campsite.suitableFor.join(', ').toLowerCase()}',
    );
    features.add('Competitive pricing at ${campsite.formattedPrice}');

    // Add some general features
    features.addAll([
      'Peaceful and secluded natural environment',
      'Clear night skies perfect for stargazing',
      'Well-maintained facilities and grounds',
    ]);

    return features;
  }

  List<Widget> _buildFeaturesContent(Campsite campsite) {
    // Build amenities based on actual campsite data
    final amenities = <Map<String, dynamic>>[
      if (campsite.isCloseToWater)
        {'icon': Icons.water, 'label': 'Water Access'},
      if (campsite.isCampFireAllowed)
        {'icon': Icons.local_fire_department, 'label': 'Campfire Allowed'},
      {
        'icon': Icons.language,
        'label': '${campsite.hostLanguages.length} Languages',
      },
      {'icon': Icons.euro, 'label': campsite.formattedPrice},
      ...campsite.suitableFor.map(
        (category) => {'icon': _getCategoryIcon(category), 'label': category},
      ),
      // Add some standard amenities
      {'icon': Icons.wc, 'label': 'Restrooms'},
      {'icon': Icons.local_parking, 'label': 'Parking'},
      {'icon': Icons.kitchen, 'label': 'Picnic Area'},
    ];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campsite Features & Amenities',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Here are the available features and amenities at ${campsite.label}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= amenities.length) return null;
            final amenity = amenities[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    amenity['icon'] as IconData,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      amenity['label'] as String,
                      style: AppTextStyles.bodyMediumWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }, childCount: amenities.length),
        ),
      ),
    ];
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'families':
      case 'family':
        return Icons.family_restroom;
      case 'couples':
      case 'couple':
        return Icons.favorite;
      case 'solo':
      case 'solo travelers':
        return Icons.person;
      case 'groups':
      case 'group':
        return Icons.group;
      case 'pets':
      case 'pet-friendly':
        return Icons.pets;
      default:
        return Icons.outdoor_grill;
    }
  }

  List<Widget> _buildGalleryContent() {
    return [
      SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Gallery coming soon!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildReviewsContent() {
    // Calculate average rating
    double averageRating =
        _reviews.fold(0.0, (sum, review) => sum + review['rating']) /
        _reviews.length;

    return [
      // Reviews Header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Reviews', style: AppTextStyles.headingMedium),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: AppTextStyles.headingSmallWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${_reviews.length} reviews)',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < averageRating.floor()
                        ? Icons.star
                        : index < averageRating
                        ? Icons.star_half
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // Reviews List
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= _reviews.length) return null;
          final review = _reviews[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reviewer info and rating
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        review['avatar'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'],
                            style: AppTextStyles.headingSmallWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < review['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 14,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                review['date'],
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Review comment
                Text(review['comment'], style: AppTextStyles.bodyLarge),
              ],
            ),
          );
        }, childCount: _reviews.length),
      ),
    ];
  }

  Widget _buildActionButtons(Campsite campsite) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Booking feature coming soon!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: AppColors.textPrimary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Book ${campsite.formattedPrice}',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
