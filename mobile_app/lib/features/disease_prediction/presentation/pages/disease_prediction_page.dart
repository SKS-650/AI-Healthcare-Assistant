import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class DiseasePredictionPage extends StatefulWidget {
  const DiseasePredictionPage({super.key});
  @override
  State<DiseasePredictionPage> createState() =>
      _DiseasePredictionPageState();
}

class _DiseasePredictionPageState extends State<DiseasePredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedSymptoms = [];
  String _selectedAge = '25-34';
  String _selectedGender = 'Male';
  double _severity = 4;
  bool _isAnalyzing = false;
  bool _showResult = false;

  final List<String> _symptoms = [
    'Fever', 'Cough', 'Headache', 'Fatigue', 'Sore Throat',
    'Shortness of Breath', 'Chest Pain', 'Nausea', 'Vomiting',
    'Diarrhea', 'Body Ache', 'Chills', 'Loss of Taste/Smell',
    'Rash', 'Joint Pain', 'Dizziness', 'Abdominal Pain',
  ];

  final List<Map<String, dynamic>> _diseases = [
    {
      'name': 'Common Cold',
      'confidence': 88,
      'risk': 'Low',
      'color': AppColors.accent,
      'dept': 'General Medicine',
      'description':
          'A viral infection of your nose and throat (upper respiratory tract).',
      'causes': 'Rhinovirus, coronavirus, respiratory syncytial virus',
      'prevention': 'Wash hands frequently, avoid close contact with sick people',
      'homecare': 'Rest, stay hydrated, take OTC medications for symptom relief',
    },
    {
      'name': 'Seasonal Flu',
      'confidence': 74,
      'risk': 'Moderate',
      'color': AppColors.warning,
      'dept': 'General Medicine',
      'description': 'A contagious respiratory illness caused by influenza viruses.',
      'causes': 'Influenza A or B virus',
      'prevention': 'Annual flu vaccine, good hygiene practices',
      'homecare': 'Rest, fluids, antiviral medications if prescribed',
    },
    {
      'name': 'COVID-19',
      'confidence': 61,
      'risk': 'High',
      'color': AppColors.emergency,
      'dept': 'Infectious Disease',
      'description': 'A respiratory illness caused by the SARS-CoV-2 virus.',
      'causes': 'SARS-CoV-2 coronavirus',
      'prevention': 'Vaccination, masking, social distancing',
      'homecare': 'Isolate, rest, monitor oxygen levels, seek care if worsening',
    },
  ];

  Future<void> _analyze() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one symptom')),
      );
      return;
    }
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isAnalyzing = false;
      _showResult = true;
    });
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
              icon: _backBtn(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _header(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: _showResult ? _buildResults() : _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backBtn() => Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.arrow_back_rounded,
            size: 18, color: AppColors.textPrimary),
      );

  Widget _header() => Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(children: [
              Text('Disease Prediction', style: AppTextStyles.headlineLarge),
              const SizedBox(width: 8),
              _aiBadge(),
            ]),
            Text('AI-powered disease analysis',
                style: AppTextStyles.bodySmall),
          ],
        ),
      );

  Widget _aiBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: AppColors.gradientPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                size: 11, color: Colors.white),
            const SizedBox(width: 4),
            Text('AI',
                style: AppTextStyles.caption.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Patient Information', Icons.person_rounded),
          const SizedBox(height: 12),
          _rowFields(),
          const SizedBox(height: 20),
          _sectionLabel('Select Symptoms', Icons.medical_information_rounded),
          const SizedBox(height: 12),
          _symptomsGrid(),
          const SizedBox(height: 20),
          _sectionLabel('Severity', Icons.thermostat_rounded),
          const SizedBox(height: 12),
          _severityCard(),
          const SizedBox(height: 28),
          _analyzeBtn(),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, IconData icon) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.titleMedium),
        ],
      );

  Widget _rowFields() => Row(
        children: [
          Expanded(child: _dropdownCard('Age Group', _selectedAge,
              ['18-24', '25-34', '35-44', '45-54', '55+'],
              (v) => setState(() => _selectedAge = v!))),
          const SizedBox(width: 12),
          Expanded(child: _dropdownCard('Gender', _selectedGender,
              ['Male', 'Female', 'Other'],
              (v) => setState(() => _selectedGender = v!))),
        ],
      );

  Widget _dropdownCard(String label, String value, List<String> items,
      void Function(String?) onChanged) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.surfaceVariant,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            hint: Text(label, style: AppTextStyles.bodySmall),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
      );

  Widget _symptomsGrid() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _symptoms.map((s) {
          final selected = _selectedSymptoms.contains(s);
          return AnimatedPress(
            onTap: () => setState(() {
              selected
                  ? _selectedSymptoms.remove(s)
                  : _selectedSymptoms.add(s);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.check_rounded,
                          size: 12, color: AppColors.primary),
                    ),
                  Text(s,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      )),
                ],
              ),
            ),
          );
        }).toList(),
      );

  Widget _severityCard() => Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pain/Discomfort Level',
                    style: AppTextStyles.titleSmall),
                _severityBadge(),
              ],
            ),
            Slider(
              value: _severity,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _severity = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mild',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accent)),
                Text('Moderate',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.warning)),
                Text('Severe',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.emergency)),
              ],
            ),
          ],
        ),
      );

  Widget _severityBadge() {
    final color = _severity <= 3
        ? AppColors.accent
        : _severity <= 6
            ? AppColors.warning
            : AppColors.emergency;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text('${_severity.round()}/10',
          style: AppTextStyles.labelMedium.copyWith(color: color)),
    );
  }

  Widget _analyzeBtn() => AnimatedPress(
        onTap: _isAnalyzing ? null : _analyze,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.gradientPrimary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            boxShadow: AppColors.shadowPrimary,
          ),
          child: Center(
            child: _isAnalyzing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.biotech_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Analyze ${_selectedSymptoms.length} Symptom'
                          '${_selectedSymptoms.length != 1 ? 's' : ''}',
                          style: AppTextStyles.titleSmall
                              .copyWith(color: Colors.white)),
                    ],
                  ),
          ),
        ),
      );

  Widget _buildResults() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to form
          AnimatedPress(
            onTap: () => setState(() => _showResult = false),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_rounded,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('Modify Symptoms',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Top Predicted Diseases',
              Icons.analytics_rounded),
          const SizedBox(height: 12),
          ..._diseases.map((d) => _DiseaseResultCard(disease: d)),
          const SizedBox(height: 16),
          _disclaimer(),
        ],
      );

  Widget _disclaimer() => Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppColors.warning, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'These predictions are AI-assisted and for educational purposes only. Always consult a qualified healthcare professional.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.warning.withValues(alpha: 0.85)),
              ),
            ),
          ],
        ),
      );
}

class _DiseaseResultCard extends StatefulWidget {
  const _DiseaseResultCard({required this.disease});
  final Map<String, dynamic> disease;
  @override
  State<_DiseaseResultCard> createState() => _DiseaseResultCardState();
}

class _DiseaseResultCardState extends State<_DiseaseResultCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final d = widget.disease;
    final Color color = d['color'] as Color;
    return AnimatedPress(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: AppColors.shadowCard,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
              child: Row(
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.25)),
                    ),
                    child: Icon(Icons.coronavirus_rounded,
                        color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['name'] as String,
                            style: AppTextStyles.titleMedium),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (d['confidence'] as int) / 100,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text('Dept: ${d['dept']}',
                              style: AppTextStyles.caption),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: color.withValues(alpha: 0.25)),
                        ),
                        child: Text('${d['confidence']}%',
                            style: AppTextStyles.labelLarge
                                .copyWith(color: color)),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _expanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: AppColors.textTertiary, size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_expanded) _expandedDetails(d, color),
          ],
        ),
      ),
    );
  }

  Widget _expandedDetails(Map<String, dynamic> d, Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          _detailItem('Description', d['description'] as String,
              Icons.description_outlined),
          _detailItem('Causes', d['causes'] as String,
              Icons.science_outlined),
          _detailItem('Prevention', d['prevention'] as String,
              Icons.shield_outlined),
          _detailItem('Home Care', d['homecare'] as String,
              Icons.home_outlined),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value, IconData icon) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                  Text(value, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      );
}
