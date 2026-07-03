import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});
  @override
  State<HealthRecordsPage> createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  int _tabIndex = 0;

  final List<_MedRecord> _predictions = [
    _MedRecord('Common Cold Risk', 'Symptom Analysis', '88%', '2 days ago',
        AppColors.warning, Icons.biotech_rounded),
    _MedRecord('Seasonal Allergy', 'Symptom Analysis', '74%', '5 days ago',
        AppColors.primary, Icons.biotech_rounded),
    _MedRecord('Mild Fever', 'Symptom Analysis', '65%', '2 weeks ago',
        AppColors.accent, Icons.biotech_rounded),
  ];

  final List<_MedRecord> _consultations = [
    _MedRecord('Dr. Sharma - General', 'Consultation', 'Completed',
        '3 days ago', AppColors.accent, Icons.medical_services_rounded),
    _MedRecord('Dr. Patel - Cardiology', 'Specialist', 'Completed',
        '2 weeks ago', AppColors.primary, Icons.favorite_rounded),
  ];

  final List<_MedRecord> _prescriptions = [
    _MedRecord('Paracetamol 500mg', 'Prescription', '3x daily',
        '3 days ago', AppColors.warning, Icons.medication_rounded),
    _MedRecord('Cetirizine 10mg', 'Prescription', '1x daily',
        '2 weeks ago', AppColors.primary, Icons.medication_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() => _tabIndex = _tabCtrl.index);
      });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedPress(
                  onTap: () => _showAddSheet(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('Add', style: AppTextStyles.labelMedium
                            .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Health Records',
                        style: AppTextStyles.headlineLarge),
                    Text('Your complete medical history',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Health summary card
                _summaryCard(),
                // Tabs
                Container(
                  color: AppColors.background,
                  child: TabBar(
                    controller: _tabCtrl,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textTertiary,
                    labelStyle: AppTextStyles.titleSmall,
                    tabs: const [
                      Tab(text: 'Predictions'),
                      Tab(text: 'Consultations'),
                      Tab(text: 'Prescriptions'),
                      Tab(text: 'Chronic'),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildTabContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() => Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A3A6E), Color(0xFF0F2A54)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryItem('3', 'Predictions', Icons.biotech_rounded),
            _vDivider(),
            _summaryItem('2', 'Consultations', Icons.medical_services_rounded),
            _vDivider(),
            _summaryItem('2', 'Prescriptions', Icons.medication_rounded),
            _vDivider(),
            _summaryItem('0', 'Reports', Icons.folder_rounded),
          ],
        ),
      );

  Widget _summaryItem(String count, String label, IconData icon) => Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(height: 4),
          Text(count, style: AppTextStyles.headlineSmall
              .copyWith(color: AppColors.textPrimary)),
          Text(label, style: AppTextStyles.caption),
        ],
      );

  Widget _vDivider() => Container(
        width: 1, height: 40,
        color: Colors.white.withValues(alpha: 0.1));

  Widget _buildTabContent() {
    return switch (_tabIndex) {
      0 => _recordsList(_predictions),
      1 => _recordsList(_consultations),
      2 => _recordsList(_prescriptions),
      _ => _chronicDiseases(),
    };
  }

  Widget _recordsList(List<_MedRecord> records) {
    if (records.isEmpty) return _emptyState();
    return Column(
      children: records.map((r) => _RecordCard(record: r)).toList(),
    );
  }

  Widget _chronicDiseases() => Column(
        children: [
          _addChronicBtn(),
          const SizedBox(height: 12),
          _emptyState(
              message:
                  'No chronic conditions recorded.\nTap + to add your medical conditions.'),
        ],
      );

  Widget _addChronicBtn() => AnimatedPress(
        onTap: _showAddSheet,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('Add Chronic Condition',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      );

  Widget _emptyState({String? message}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.folder_open_rounded,
                  size: 30, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 14),
            Text(message ?? 'No records yet',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      );

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24, right: 24, top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Health Record',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 20),
            _sheetOption(Icons.biotech_rounded, 'Add Prediction Result',
                AppColors.primary),
            _sheetOption(Icons.medication_rounded,
                'Add Prescription', AppColors.warning),
            _sheetOption(Icons.folder_rounded,
                'Upload Lab Report', AppColors.accent),
            _sheetOption(Icons.medical_services_rounded,
                'Add Consultation Note', const Color(0xFF8B5CF6)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sheetOption(IconData icon, String label, Color color) =>
      ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(label, style: AppTextStyles.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: AppColors.textTertiary),
        onTap: () => Navigator.pop(context),
      );
}

class _MedRecord {
  final String title, type, value, date;
  final Color color;
  final IconData icon;
  const _MedRecord(
      this.title, this.type, this.value, this.date, this.color, this.icon);
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});
  final _MedRecord record;

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.shadowCard,
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: record.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                    color: record.color.withValues(alpha: 0.25)),
              ),
              child: Icon(record.icon, color: record.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.title, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 3),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: record.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(record.type,
                          style: AppTextStyles.caption.copyWith(
                              color: record.color,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    Text(record.date, style: AppTextStyles.caption),
                  ]),
                ],
              ),
            ),
            Text(record.value,
                style: AppTextStyles.labelLarge
                    .copyWith(color: record.color)),
          ],
        ),
      ),
    );
  }
}
