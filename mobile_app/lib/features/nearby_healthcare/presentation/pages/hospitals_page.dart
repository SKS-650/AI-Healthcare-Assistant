import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});
  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  String _filter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All', 'Hospitals', 'Clinics', 'Pharmacies', 'Ambulance'
  ];

  final List<_Facility> _facilities = [
    _Facility('City General Hospital', 'Hospital', '1.2 km',
        '123 Health Ave, Downtown', '+1-555-0100', true,
        '24/7', Icons.local_hospital_rounded, AppColors.primary),
    _Facility('St. Mary Healthcare Center', 'Hospital', '3.5 km',
        '789 Care Rd, Suburbia', '+1-555-0200', true,
        '24/7', Icons.local_hospital_rounded, AppColors.primary),
    _Facility('Green Valley Clinic', 'Clinic', '0.8 km',
        '45 Wellness St, Midtown', '+1-555-0300', true,
        '8am-8pm', Icons.medical_services_rounded, AppColors.accent),
    _Facility('LifeCare Pharmacy', 'Pharmacy', '0.4 km',
        '12 Medicine Lane', '+1-555-0400', true,
        '7am-10pm', Icons.local_pharmacy_rounded, const Color(0xFF8B5CF6)),
    _Facility('QuickCare Pharmacy', 'Pharmacy', '2.1 km',
        '88 Health Blvd', '+1-555-0500', false,
        'Closed', Icons.local_pharmacy_rounded, const Color(0xFF8B5CF6)),
    _Facility('City Ambulance Service', 'Ambulance', '–',
        'Serving entire city area', '+1-555-0911', true,
        '24/7', Icons.emergency_rounded, AppColors.emergency),
    _Facility('Rural Health Clinic', 'Clinic', '5.2 km',
        '99 Village Rd, Outskirts', '+1-555-0600', false,
        'Mon-Sat 9am-5pm', Icons.medical_services_rounded, AppColors.accent),
  ];

  List<_Facility> get _filtered => _facilities.where((f) {
        final matchFilter = _filter == 'All' || f.type == _filter;
        final matchSearch = _searchQuery.isEmpty ||
            f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f.address.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchFilter && matchSearch;
      }).toList();

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    size: 18, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Nearby Healthcare',
                        style: AppTextStyles.headlineLarge),
                    Text('Hospitals, Clinics & Pharmacies near you',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search hospitals, clinics...',
                        hintStyle: AppTextStyles.bodySmall,
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textTertiary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final selected = _filter == _filters[i];
                        return AnimatedPress(
                          onTap: () =>
                              setState(() => _filter = _filters[i]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(_filters[i],
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results count
                  Text('${_filtered.length} facilities found',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 12),

                  // Facility cards
                  ..._filtered.map((f) => _FacilityCard(
                        facility: f,
                        onCall: () => _call(f.phone),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Facility {
  final String name, type, distance, address, phone, hours;
  final bool isOpen;
  final IconData icon;
  final Color color;
  const _Facility(this.name, this.type, this.distance, this.address,
      this.phone, this.isOpen, this.hours, this.icon, this.color);
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility, required this.onCall});
  final _Facility facility;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.shadowCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: facility.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: facility.color.withValues(alpha: 0.25)),
                  ),
                  child: Icon(facility.icon,
                      color: facility.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(facility.name,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: facility.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(facility.type,
                              style: AppTextStyles.caption.copyWith(
                                  color: facility.color,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 6),
                        if (facility.distance != '–') ...[
                          const Icon(Icons.near_me_rounded,
                              size: 11,
                              color: AppColors.textTertiary),
                          const SizedBox(width: 3),
                          Text(facility.distance,
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ]),
                    ],
                  ),
                ),
                // Open/Closed badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: facility.isOpen
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : AppColors.emergency.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: facility.isOpen
                              ? AppColors.accent
                              : AppColors.emergency,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(facility.isOpen ? 'Open' : 'Closed',
                          style: AppTextStyles.caption.copyWith(
                            color: facility.isOpen
                                ? AppColors.accent
                                : AppColors.emergency,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 12, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(facility.address,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: 12, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(facility.hours, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: AnimatedPress(
                  onTap: onCall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone_rounded,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text('Call',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.accent)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnimatedPress(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation_rounded,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Navigate',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
