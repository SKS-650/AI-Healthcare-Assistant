import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});
  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Disease', 'Nutrition', 'Hygiene',
    'Maternal', 'Child', 'Vaccination', 'Seasonal',
  ];

  final List<_Article> _articles = [
    _Article('Understanding Malaria: Causes, Prevention & Treatment',
        'Disease', '6 min', Icons.coronavirus_rounded, AppColors.emergency,
        'Malaria is a life-threatening disease caused by parasites transmitted '
        'through the bite of infected female Anopheles mosquitoes.\n\n'
        '🔹 Symptoms: Fever, chills, headache, vomiting\n'
        '🔹 Prevention: Sleep under insecticide-treated nets, use repellents\n'
        '🔹 Treatment: Seek prompt medical care, take antimalarial drugs\n\n'
        'Early diagnosis and treatment are key to preventing complications.'),
    _Article('Clean Hands Save Lives: Hand Hygiene Guide',
        'Hygiene', '4 min', Icons.clean_hands_rounded, AppColors.primary,
        'Proper handwashing is one of the most effective ways to prevent the '
        'spread of infections.\n\n'
        '✅ Wash with soap and water for at least 20 seconds\n'
        '✅ Use alcohol-based hand sanitizer when soap unavailable\n'
        '✅ Wash before eating, after toilet, after caring for sick\n\n'
        'Regular handwashing can reduce diarrheal illness by 30%.'),
    _Article('Balanced Diet for Rural Families',
        'Nutrition', '5 min', Icons.restaurant_rounded, AppColors.accent,
        'A nutritious diet prevents malnutrition and chronic diseases.\n\n'
        '🥗 Include variety: grains, vegetables, legumes, fruits\n'
        '💧 Drink clean water: at least 8 glasses daily\n'
        '🥚 Include protein: eggs, beans, lentils, fish\n'
        '🌿 Eat leafy greens for iron and vitamins\n\n'
        'Avoid processed foods high in salt, sugar, and unhealthy fats.'),
    _Article('Maternal Healthcare: Before and After Delivery',
        'Maternal', '8 min', Icons.pregnant_woman_rounded,
        const Color(0xFFEC4899),
        'Prenatal and postnatal care is essential for mother and baby health.\n\n'
        '📅 Attend all antenatal checkups (at least 4 visits)\n'
        '💊 Take iron and folic acid supplements\n'
        '🏥 Deliver in a health facility with skilled attendants\n'
        '🤱 Breastfeed exclusively for first 6 months\n\n'
        'Warning signs: Excessive bleeding, severe headache, blurred vision.'),
    _Article('Child Vaccination Schedule',
        'Vaccination', '5 min', Icons.vaccines_rounded, AppColors.warning,
        'Vaccines protect children from life-threatening diseases.\n\n'
        '📅 Birth: BCG, Hepatitis B, OPV-0\n'
        '📅 6 weeks: DTP, HepB, Hib, PCV, Rota, OPV\n'
        '📅 10 weeks: DTP, HepB, Hib, PCV, Rota, OPV\n'
        '📅 14 weeks: DTP, HepB, Hib, PCV, OPV\n'
        '📅 9 months: Measles, Yellow Fever\n\n'
        'Keep vaccination card safe and attend all scheduled visits.'),
    _Article('Cholera Prevention in Rural Areas',
        'Disease', '5 min', Icons.water_drop_rounded, AppColors.primary,
        'Cholera spreads through contaminated water and food.\n\n'
        '💧 Drink only safe, boiled or treated water\n'
        '🚿 Wash hands with soap and water\n'
        '🥘 Cook food thoroughly and eat while hot\n'
        '🚽 Use latrines and dispose waste properly\n\n'
        'If you suspect cholera, seek immediate medical attention.'),
    _Article('Dengue Fever: Prevention & Awareness',
        'Seasonal', '4 min', Icons.bug_report_rounded, AppColors.warning,
        'Dengue is spread by Aedes mosquitoes, primarily during daytime.\n\n'
        '🦟 Eliminate standing water where mosquitoes breed\n'
        '🛏 Sleep under mosquito nets\n'
        '👕 Wear long-sleeved clothing\n'
        '⚠️ Warning signs: Severe abdominal pain, vomiting blood\n\n'
        'No specific antiviral treatment. Hospitalization may be needed.'),
    _Article('Child Growth & Development Milestones',
        'Child', '6 min', Icons.child_care_rounded, AppColors.accent,
        'Understanding your child\'s development helps identify concerns early.\n\n'
        '👶 0-3 months: Smiles, recognizes voices\n'
        '🧒 3-6 months: Rolls over, sits with support\n'
        '🏃 12 months: Stands, takes first steps\n'
        '💬 18 months: Says several words\n\n'
        'Regular checkups with a pediatrician are recommended.'),
  ];

  List<_Article> get _filtered =>
      _selectedCategory == 'All'
          ? _articles
          : _articles.where((a) => a.category == _selectedCategory).toList();

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
                    Text('Health Education',
                        style: AppTextStyles.headlineLarge),
                    Text('Curated medical intelligence for rural health',
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
                  // Offline badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.offline_bolt_rounded,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text('Available Offline',
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category filter
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final sel = _selectedCategory == _categories[i];
                        return AnimatedPress(
                          onTap: () => setState(
                              () => _selectedCategory = _categories[i]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull),
                              border: Border.all(
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(_categories[i],
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: sel
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text('${_filtered.length} Articles',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 12),

                  ..._filtered.map((a) => _ArticleCard(article: a)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Article {
  final String title, category, readTime, content;
  final IconData icon;
  final Color color;
  const _Article(this.title, this.category, this.readTime,
      this.icon, this.color, this.content);
}

class _ArticleCard extends StatefulWidget {
  const _ArticleCard({required this.article});
  final _Article article;
  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;
    return AnimatedPress(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: _expanded
                ? a.color.withValues(alpha: 0.3)
                : AppColors.border,
          ),
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
                      color: a.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: a.color.withValues(alpha: 0.25)),
                    ),
                    child: Icon(a.icon, color: a.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: a.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(a.category,
                              style: AppTextStyles.caption.copyWith(
                                  color: a.color,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 5),
                        Text(a.title,
                            style: AppTextStyles.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.access_time_rounded,
                              size: 11, color: AppColors.textTertiary),
                          const SizedBox(width: 3),
                          Text(a.readTime,
                              style: AppTextStyles.caption),
                          const SizedBox(width: 8),
                          const Icon(Icons.offline_bolt_rounded,
                              size: 11, color: AppColors.accent),
                          const SizedBox(width: 3),
                          Text('Offline',
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.accent)),
                        ]),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.textTertiary, size: 20,
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 14),
                    Text(a.content,
                        style: AppTextStyles.bodyMedium
                            .copyWith(height: 1.7)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
