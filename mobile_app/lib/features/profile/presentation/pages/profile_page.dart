import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editMode = false;

  final _nameCtrl = TextEditingController(text: 'John Doe');
  final _ageCtrl = TextEditingController(text: '28');
  final _phoneCtrl = TextEditingController(text: '+1 555-0100');
  final _emergencyCtrl = TextEditingController(text: '+1 555-0200');

  String _bloodGroup = 'O+';
  String _gender = 'Male';
  String _language = 'English';

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _languages = ['English', 'Nepali', 'Hindi', 'Bhojpuri'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _phoneCtrl.dispose();
    _emergencyCtrl.dispose();
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
            expandedHeight: 200,
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
                  onTap: () => setState(() => _editMode = !_editMode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _editMode
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _editMode
                            ? AppColors.accent.withValues(alpha: 0.4)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _editMode
                              ? Icons.check_rounded
                              : Icons.edit_rounded,
                          size: 14,
                          color: _editMode
                              ? AppColors.accent
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _editMode ? 'Save' : 'Edit',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: _editMode
                                ? AppColors.accent
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _profileHeader(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard('Personal Information', [
                    _field('Full Name', _nameCtrl, Icons.person_rounded),
                    _field('Age', _ageCtrl, Icons.cake_rounded, isNumber: true),
                    _field('Phone', _phoneCtrl, Icons.phone_rounded,
                        isPhone: true),
                    _dropdown('Gender', _gender, _genders,
                        Icons.wc_rounded,
                        (v) => setState(() => _gender = v!)),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard('Medical Information', [
                    _dropdown('Blood Group', _bloodGroup, _bloodGroups,
                        Icons.bloodtype_rounded,
                        (v) => setState(() => _bloodGroup = v!)),
                    _field('Emergency Contact', _emergencyCtrl,
                        Icons.emergency_rounded, isPhone: true),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard('App Preferences', [
                    _dropdown('Language', _language, _languages,
                        Icons.language_rounded,
                        (v) => setState(() => _language = v!)),
                  ]),
                  const SizedBox(height: 16),
                  _healthStats(),
                  const SizedBox(height: 24),
                  _logoutBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() => Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 86, height: 86,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3), width: 3),
                boxShadow: AppColors.shadowPrimary,
              ),
              child: Center(
                child: Text('JD',
                    style: AppTextStyles.headlineLarge
                        .copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            Text('John Doe', style: AppTextStyles.headlineSmall),
            Text('Patient ID: #HC-2024-0001',
                style: AppTextStyles.caption),
            const SizedBox(height: 20),
          ],
        ),
      );

  Widget _sectionCard(String title, List<Widget> children) => Container(
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
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      );

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool isNumber = false, bool isPhone = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption),
                  _editMode
                      ? TextField(
                          controller: ctrl,
                          style: AppTextStyles.titleSmall,
                          keyboardType: isNumber
                              ? TextInputType.number
                              : isPhone
                                  ? TextInputType.phone
                                  : TextInputType.text,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 4),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(ctrl.text,
                          style: AppTextStyles.titleSmall),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _dropdown(String label, String value, List<String> items,
      IconData icon, void Function(String?) onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption),
                  _editMode
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: value,
                            isDense: true,
                            dropdownColor: AppColors.surfaceVariant,
                            style: AppTextStyles.titleSmall,
                            items: items
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: onChanged,
                          ),
                        )
                      : Text(value,
                          style: AppTextStyles.titleSmall),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _healthStats() => Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A3A6E), Color(0xFF0F2A54)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health Summary',
                style: AppTextStyles.titleLarge
                    .copyWith(color: AppColors.primaryLight)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('3', 'Predictions', Icons.biotech_rounded),
                _statDivider(),
                _statItem('85', 'Health Score', Icons.favorite_rounded),
                _statDivider(),
                _statItem('O+', 'Blood Group', Icons.bloodtype_rounded),
              ],
            ),
          ],
        ),
      );

  Widget _statItem(String value, String label, IconData icon) =>
      Column(children: [
        Icon(icon, size: 18, color: AppColors.primaryLight),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headlineSmall),
        Text(label, style: AppTextStyles.caption),
      ]);

  Widget _statDivider() => Container(
      width: 1, height: 40,
      color: Colors.white.withValues(alpha: 0.1));

  Widget _logoutBtn() => AnimatedPress(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.emergency.withValues(alpha: 0.08),
            borderRadius:
                BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
                color: AppColors.emergency.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded,
                  color: AppColors.emergency, size: 18),
              const SizedBox(width: 8),
              Text('Sign Out',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.emergency)),
            ],
          ),
        ),
      );
}
