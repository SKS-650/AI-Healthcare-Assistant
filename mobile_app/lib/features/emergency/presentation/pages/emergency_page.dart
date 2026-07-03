import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});
  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  String? _selectedEmergency;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _emergencies = [
    {'id': 'chest', 'title': 'Chest Pain', 'icon': Icons.favorite_rounded, 'color': AppColors.emergency, 'risk': 'Critical'},
    {'id': 'stroke', 'title': 'Stroke', 'icon': Icons.psychology_rounded, 'color': AppColors.emergency, 'risk': 'Critical'},
    {'id': 'bleeding', 'title': 'Severe Bleeding', 'icon': Icons.bloodtype_rounded, 'color': AppColors.emergency, 'risk': 'High'},
    {'id': 'breathing', 'title': 'Breathing Difficulty', 'icon': Icons.air_rounded, 'color': AppColors.warning, 'risk': 'High'},
    {'id': 'fever', 'title': 'High Fever (>40°C)', 'icon': Icons.thermostat_rounded, 'color': AppColors.warning, 'risk': 'Moderate'},
    {'id': 'snake', 'title': 'Snake Bite', 'icon': Icons.warning_rounded, 'color': AppColors.emergency, 'risk': 'Critical'},
    {'id': 'poison', 'title': 'Poisoning', 'icon': Icons.science_rounded, 'color': AppColors.warning, 'risk': 'High'},
    {'id': 'accident', 'title': 'Accident / Trauma', 'icon': Icons.car_crash_rounded, 'color': AppColors.emergency, 'risk': 'High'},
  ];

  final Map<String, List<String>> _instructions = {
    'chest': [
      'Call emergency services immediately (911/102)',
      'Have the person sit or lie down comfortably',
      'Loosen tight clothing around chest/neck',
      'Give aspirin (325mg) if not allergic and conscious',
      'Begin CPR if person becomes unresponsive',
      'Stay with the person until help arrives',
    ],
    'stroke': [
      'Use FAST: Face drooping, Arm weakness, Speech difficulty, Time to call',
      'Call emergency services immediately',
      'Note the time symptoms started',
      'Do NOT give food or water',
      'Keep person calm and lying down',
      'Do NOT leave person alone',
    ],
    'bleeding': [
      'Apply direct pressure with clean cloth',
      'Do NOT remove embedded objects',
      'Elevate the injured area above heart',
      'Apply pressure bandage if available',
      'Call emergency services for severe bleeding',
      'Keep patient warm and calm',
    ],
    'breathing': [
      'Call emergency services immediately',
      'Help person sit upright for easier breathing',
      'Loosen tight clothing',
      'If prescribed, help with inhaler/medication',
      'Monitor breathing rate and consciousness',
      'Begin CPR if breathing stops',
    ],
    'fever': [
      'Take paracetamol (follow dosage instructions)',
      'Apply cool damp cloth to forehead',
      'Keep patient well hydrated',
      'Remove excess clothing/blankets',
      'Monitor temperature every 30 minutes',
      'Seek medical care if fever > 39.5°C or persists',
    ],
    'snake': [
      'Keep victim calm and still – movement spreads venom',
      'Remove jewelry and tight clothing near bite',
      'Keep bitten limb BELOW heart level',
      'Do NOT suck venom or cut the wound',
      'Do NOT apply tourniquet or ice',
      'Transport to hospital IMMEDIATELY for antivenom',
    ],
    'poison': [
      'Call Poison Control immediately',
      'Do NOT induce vomiting unless advised',
      'Keep container/label of suspected substance',
      'Note time and amount of exposure',
      'If unconscious, place in recovery position',
      'Go to emergency room immediately',
    ],
    'accident': [
      'Ensure scene is safe before approaching',
      'Call emergency services (911/102/108)',
      'Do NOT move victim unless in immediate danger',
      'Control any bleeding with direct pressure',
      'Keep victim warm and conscious',
      'Provide reassurance until help arrives',
    ],
  };

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:102');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
                    Text('Emergency', style: AppTextStyles.headlineLarge
                        .copyWith(color: AppColors.emergency)),
                    Text('Tap SOS or select your emergency type',
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
                  _sosSection(),
                  const SizedBox(height: 28),
                  _emergencyContacts(),
                  const SizedBox(height: 28),
                  _emergencyTypes(),
                  if (_selectedEmergency != null) ...[
                    const SizedBox(height: 20),
                    _instructionsCard(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sosSection() => Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A0A0A), Color(0xFF1A0505)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.emergency.withValues(alpha: 0.3)),
          boxShadow: AppColors.shadowEmergency,
        ),
        child: Column(
          children: [
            Text('Emergency SOS', style: AppTextStyles.headlineSmall
                .copyWith(color: AppColors.emergencyLight)),
            const SizedBox(height: 6),
            Text('Press & hold to call emergency services',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.emergency.withValues(alpha: 0.7))),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: _pulseAnim.value,
                child: AnimatedPress(
                  onTap: _callEmergency,
                  scale: 0.92,
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientEmergency,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.5),
                          blurRadius: 30, spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone_in_talk_rounded,
                            color: Colors.white, size: 28),
                        Text('SOS', style: AppTextStyles.titleMedium
                            .copyWith(color: Colors.white,
                                letterSpacing: 2)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _emergencyContacts() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Emergency Numbers', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _contactBtn('Ambulance', '102',
                  Icons.local_hospital_rounded, AppColors.emergency)),
              const SizedBox(width: 10),
              Expanded(child: _contactBtn('Police', '100',
                  Icons.local_police_rounded, AppColors.primary)),
              const SizedBox(width: 10),
              Expanded(child: _contactBtn('Fire', '101',
                  Icons.local_fire_department_rounded, AppColors.warning)),
            ],
          ),
        ],
      );

  Widget _contactBtn(String label, String number, IconData icon, Color color) =>
      AnimatedPress(
        onTap: () async {
          final uri = Uri.parse('tel:$number');
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.labelSmall
                  .copyWith(color: color)),
              Text(number, style: AppTextStyles.titleSmall
                  .copyWith(color: color)),
            ],
          ),
        ),
      );

  Widget _emergencyTypes() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Emergency Type',
              style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Get step-by-step first aid instructions',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.4,
            ),
            itemCount: _emergencies.length,
            itemBuilder: (context, i) {
              final e = _emergencies[i];
              final selected = _selectedEmergency == e['id'];
              final color = e['color'] as Color;
              return AnimatedPress(
                onTap: () => setState(() =>
                    _selectedEmergency =
                        selected ? null : e['id'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: selected
                          ? color.withValues(alpha: 0.5)
                          : AppColors.border,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(e['icon'] as IconData,
                            color: color, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(e['title'] as String,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: selected
                                    ? color
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );

  Widget _instructionsCard() {
    final e = _emergencies
        .firstWhere((e) => e['id'] == _selectedEmergency);
    final steps = _instructions[_selectedEmergency] ?? [];
    final color = e['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(e['icon'] as IconData, color: color, size: 22),
            const SizedBox(width: 10),
            Text('${e['title']} First Aid',
                style: AppTextStyles.headlineSmall),
          ]),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${e['risk']} Risk',
                style: AppTextStyles.labelSmall
                    .copyWith(color: color, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: color.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text('${entry.key + 1}',
                            style: AppTextStyles.caption.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(entry.value,
                            style: AppTextStyles.bodyMedium)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
